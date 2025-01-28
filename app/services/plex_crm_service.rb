# Service for interacting with Plex CRM API
# Handles sending applications/requests to the CRM system
class PlexCrmService
  include HTTParty
  base_uri 'https://plex-crm.ru/api/v3'

  APPLICATION_TYPES = {
    credit: 'credit',
    installment: 'hire-purchase',
    buyout: 'buyout',
    exchange: 'trade-in',
    call_request: 'callback'
  }.freeze

  COMMENTS = {
    credit: 'Заявка на кредит',
    installment: 'Заявка на рассрочку',
    buyout: 'Заявка на выкуп автомобиля',
    exchange: 'Заявка на обмен автомобиля (Trade-in)',
    call_request: ->(request) { "Заявка на обратный звонок#{request.preferred_time ? ", предпочтительное время: #{request.preferred_time}" : ''}" }
  }.freeze

  # Initializes the service with request object for tracking parameters
  #
  # @param [ActionDispatch::Request] request Current request object containing UTM parameters
  #
  # @example
  #   PlexCrmService.new(request)
  def initialize(request = nil)
    @token = ENV['PLEX_CRM_TOKEN']
    @headers = {
      'Authorization' => "Bearer #{@token}",
      'Accept' => 'application/json'
    }
    @request = request
  end

  # Generic method for sending applications to Plex CRM
  #
  # @param [Symbol] type Type of application (:credit, :installment, :buyout, :exchange, :call_request)
  # @param [Object] application Application object containing client data
  # @return [Hash] Response from the API with status and message
  #
  # @example
  #   send_application(:credit, credit_application)
  #   # => { success: true, data: {...}, status: 200, message: "Successfully sent to Plex CRM" }
  def send_application(type, application)
    payload = send("build_#{type}_values", application)
  
    log_request(type, payload)
  
    response = self.class.post('/contact/form', {
      headers: @headers,
      body: payload
    })
  
    log_response(response)
    handle_response(response)
  end

  # Define methods for each application type
  APPLICATION_TYPES.each do |method_name, _|
    define_method("send_#{method_name}_application") do |application|
      send_application(method_name, application)
    end
  end

  private

  # Builds values for credit application
  #
  # @param [Credit] credit Credit application object
  # @return [Hash] Formatted credit application values
  def build_credit_values(credit)
    car = Car.find(credit.car_id) # Получаем данные о машине по car_id
    bank = credit.banks_id.present? ? Bank.find_by(id: credit.banks_id) : nil

    {
      type: "credit",
      source: {
        dealerId: 77,
        websiteId: ENV['SITE_ID'].to_i
      },
      dateTime: credit.created_at.strftime('%Y-%m-%d %H:%M:%S'), # Текущая дата и время
      externalId: credit.id.to_s, # Внешний ID кредита
      values: {
        clientName: credit.name.to_s, # Имя клиента
        clientPhone: credit.phone, # Телефон клиента
        offerId: car.unique_id.to_i,
        comment: COMMENTS[:credit], # Комментарий
        paymentMethod: "credit", # Метод оплаты
        bankTitle: bank&.name.to_s, # Название банка, если найден
        creditAmount: credit.initial_contribution.to_s, # Сумма кредита
        creditInitialFee: credit.initial_contribution.to_s, # Первоначальный взнос
        creditPeriod: credit.credit_term.to_s # Срок кредита
      },
      tracking: {
        utm_source: @request&.params[:utm_source],
        utm_medium: @request&.params[:utm_medium],
        utm_campaign: @request&.params[:utm_campaign],
        utm_content: @request&.params[:utm_content],
        utm_term: @request&.params[:utm_term],
        gclid: @request&.params[:gclid],
        yclid: @request&.params[:yclid],
        fbclid: @request&.params[:fbclid],
        rb_clickid: @request&.params[:rb_clickid],
        ym_goal: @request&.params[:ym_goal],
        roistat_visit: @request&.params[:roistat_visit]
      }
    }
  end

  # Builds values for installment application
  #
  # @param [Installment] installment Installment application object
  # @return [Hash] Formatted installment application values
  def build_installment_values(installment)
    car = Car.find(installment.car_id) # Получаем данные о машине по car_id

    {
      type: "hire-purchase",
      source: {
        dealerId: 77, # Замените на актуальный ID дилера
        websiteId: ENV['SITE_ID'].to_i
      },
      dateTime: installment.created_at.strftime('%Y-%m-%d %H:%M:%S'), # Текущая дата и время
      externalId: installment.id.to_s, # Внешний ID заявки
      values: {
        clientName: installment.name.to_s, # Имя клиента
        clientPhone: installment.phone, # Телефон клиента
        offerId: car.unique_id.to_i,
        comment: COMMENTS[:installment], # Комментарий
        paymentMethod: "installment", # Метод оплаты
        creditAmount: installment.initial_contribution.to_s, # Сумма кредита
        creditInitialFee: installment.initial_contribution.to_s, # Первоначальный взнос
        creditPeriod: installment.credit_term.to_s # Срок кредита
      },
      tracking: {
        utm_source: @request&.params[:utm_source],
        utm_medium: @request&.params[:utm_medium],
        utm_campaign: @request&.params[:utm_campaign],
        utm_content: @request&.params[:utm_content],
        utm_term: @request&.params[:utm_term],
        gclid: @request&.params[:gclid],
        yclid: @request&.params[:yclid],
        fbclid: @request&.params[:fbclid],
        rb_clickid: @request&.params[:rb_clickid],
        ym_goal: @request&.params[:ym_goal],
        roistat_visit: @request&.params[:roistat_visit]
      }
    }
  end

  # Builds values for buyout application
  #
  # @param [Buyout] buyout Buyout application object
  # @return [Hash] Formatted buyout application values
  def build_buyout_values(buyout)
    {
      type: "buyout",
      source: {
        dealerId: 77,
        websiteId: ENV['SITE_ID'].to_i,
      },
      dateTime: buyout.created_at.strftime('%Y-%m-%d %H:%M:%S'), # Текущая дата и время
      externalId: buyout.id.to_s, # Внешний ID заявки
      values: {
        clientName: buyout.name.to_s, # Имя клиента
        clientPhone: buyout.phone, # Телефон клиента
        comment: COMMENTS[:buyout], # Комментарий
        clientVehicleMark: buyout.brand, # Марка автомобиля
        clientVehicleModel: buyout.model, # Модель автомобиля
        clientVehicleYear: buyout.year.to_s, # Год автомобиля
        clientVehicleRun: buyout.mileage.to_s, # Пробег автомобиля
      },
      tracking: {
        utm_source: @request&.params[:utm_source],
        utm_medium: @request&.params[:utm_medium],
        utm_campaign: @request&.params[:utm_campaign],
        utm_content: @request&.params[:utm_content],
        utm_term: @request&.params[:utm_term],
        gclid: @request&.params[:gclid],
        yclid: @request&.params[:yclid],
        fbclid: @request&.params[:fbclid],
        rb_clickid: @request&.params[:rb_clickid],
        ym_goal: @request&.params[:ym_goal],
        roistat_visit: @request&.params[:roistat_visit]
      }
    }
  end

  # Builds values for exchange application
  #
  # @param [Exchange] exchange Exchange application object
  # @return [Hash] Formatted exchange application values
  def build_exchange_values(exchange)
    car = Car.find(exchange.car_id) # Получаем данные о машине по car_id

    {
      type: "trade-in",
      source: {
        dealerId: 77,
        websiteId: ENV['SITE_ID'].to_i
      },
      dateTime: exchange.created_at.strftime('%Y-%m-%d %H:%M:%S'), # Текущая дата и время
      values: {
        clientName: exchange.name.to_s, # Имя клиента
        clientPhone: exchange.phone, # Телефон клиента
        offerId: car.unique_id.to_i,
        comment: COMMENTS[:exchange], # Комментарий
        clientVehicleMark: exchange.customer_car, # Марка автомобиля
        creditAmount: exchange.initial_contribution.to_s, # Сумма кредита
        creditInitialFee: exchange.initial_contribution.to_s, # Первоначальный взнос
        creditPeriod: exchange.credit_term.to_s # Срок кредита
      },
      tracking: {
        utm_source: @request&.params[:utm_source],
        utm_medium: @request&.params[:utm_medium],
        utm_campaign: @request&.params[:utm_campaign],
        utm_content: @request&.params[:utm_content],
        utm_term: @request&.params[:utm_term],
        gclid: @request&.params[:gclid],
        yclid: @request&.params[:yclid],
        fbclid: @request&.params[:fbclid],
        rb_clickid: @request&.params[:rb_clickid],
        ym_goal: @request&.params[:ym_goal],
        roistat_visit: @request&.params[:roistat_visit]
      }
    }
  end

  # Builds values for call request application
  #
  # @param [CallRequest] call_request Call request object
  # @return [Hash] Formatted call request values
  def build_call_request_values(call_request)
    car = Car.find_by(id: call_request.car_id) # Получаем данные о машине по car_id

    {
      type: "callback",
      source: {
        dealerId: 77,
        websiteId: ENV['SITE_ID'].to_i
      },
      dateTime: call_request.created_at.strftime('%Y-%m-%d %H:%M:%S'),
      externalId: call_request.id.to_s, # Внешний ID кредита
      values: {
        clientName: call_request.name.to_s, # ФИО клиента
        clientPhone: call_request.phone, # Телефон клиента
        offerId: car&.unique_id.to_i,
        comment: COMMENTS[:call_request].call(call_request)
      },
      tracking: {
        utm_source: @request&.params[:utm_source],
        utm_medium: @request&.params[:utm_medium],
        utm_campaign: @request&.params[:utm_campaign],
        utm_content: @request&.params[:utm_content],
        utm_term: @request&.params[:utm_term],
        gclid: @request&.params[:gclid],
        yclid: @request&.params[:yclid],
        fbclid: @request&.params[:fbclid],
        rb_clickid: @request&.params[:rb_clickid],
        ym_goal: @request&.params[:ym_goal],
        roistat_visit: @request&.params[:roistat_visit]
      }
    }
  end

  # Logs outgoing request details
  #
  # @param [Symbol] type Type of application
  # @param [Hash] payload Request payload
  def log_request(type, payload)
    Rails.logger.info "Sending #{type} request to Plex CRM:"
    Rails.logger.info "URL: #{self.class.base_uri}/contact/form"
    Rails.logger.info "Headers: #{@headers}"
    Rails.logger.info "Payload: #{payload}"
  end

  # Logs incoming response details
  #
  # @param [HTTParty::Response] response Response from API
  def log_response(response)
    Rails.logger.info "Response from Plex CRM:"
    Rails.logger.info "Status: #{response.code}"
  end

  # Processes API response and formats result
  #
  # @param [HTTParty::Response] response Response from API
  # @return [Hash] Processed response with success status and message
  #
  # @example
  #   handle_response(response)
  #   # => { success: true, data: {...}, status: 200, message: "Successfully sent to Plex CRM" }
  def handle_response(response)
    success = response.success?
    message = success ? "Successfully sent to Plex CRM" : "Failed to send to Plex CRM: #{response.body}"
    Rails.logger.info "✉️  #{message}"

    {
      success: success,
      data: response.parsed_response,
      status: response.code,
      message: message
    }
  end
end
