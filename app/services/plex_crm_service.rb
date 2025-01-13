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
    payload = build_request(type, application)
    
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

  # Builds the complete request payload for CRM API
  #
  # @param [Symbol] type Type of application
  # @param [Object] application Application object
  # @return [Hash] Formatted request payload
  #
  # @example
  #   build_request(:credit, credit_application)
  #   # => { type: 'credit', source: {...}, client: {...}, values: {...}, tracking: {...} }
  def build_request(type, application)
    {
      type: APPLICATION_TYPES[type],
      source: source_params,
      dateTime: Time.current.utc.strftime('%Y-%m-%d %H:%M:%S'),
      values: send("build_#{type}_values", application),
      tracking: tracking_params
    }
  end

  # Returns source parameters for CRM identification
  #
  # @return [Hash] Dealer and website identifiers
  def source_params
    {
      dealerId: 77,
      websiteId: 627
    }
  end

  # Extracts tracking parameters from request
  #
  # @return [Hash] UTM and other tracking parameters
  def tracking_params
    return {} unless @request

    {
      utm_source: @request.params[:utm_source],
      utm_medium: @request.params[:utm_medium],
      utm_campaign: @request.params[:utm_campaign],
      utm_content: @request.params[:utm_content],
      utm_term: @request.params[:utm_term],
      gclid: @request.params[:gclid],
      yclid: @request.params[:yclid],
      fbclid: @request.params[:fbclid],
      rb_clickid: @request.params[:rb_clickid],
      ym_goal: @request.params[:ym_goal],
      roistat_visit: @request.params[:roistat_visit]
    }.compact
  end

  # Builds values for credit application
  #
  # @param [Credit] credit Credit application object
  # @return [Hash] Formatted credit application values
  def build_credit_values(credit)
    car = Car.find(credit.car_id) # Получаем данные о машине по car_id
    history_car = HistoryCar.find_by(car_id: car.id) # Получаем данные о истории машины
    generation = car.model.generations.first # Получаем генерацию через модель
    first_image_url = car.images.first&.url || "Отсутствует изображение" # Замените "string" на значение по умолчанию, если изображение отсутствует

    {
      clientPhone: credit.phone, # Телефон клиента
      type: "credit",
      source: {
        dealerId: 77,
        websiteId: 627
      },
      dateTime: Time.current.utc.strftime('%Y-%m-%d %H:%M:%S'), # Текущая дата и время
      externalId: credit.id.to_s, # Внешний ID кредита
      values: {
        clientName: credit.name, # ФИО клиента
        offerId: credit.banks_id, # ID банка
        offerExternalId: credit.id, # ID кредита
        comment: COMMENTS[:credit], # Комментарий
        paymentMethod: "credit", # Метод оплаты
        bankTitle: credit.bank&.name, # Название банка
        creditAmount: credit.initial_contribution.to_s, # Сумма кредита
        creditInitialFee: credit.initial_contribution.to_s, # Первоначальный взнос
        creditPeriod: credit.credit_term.to_s # Срок кредита
      },
      offer: {
        externalId: credit.id.to_s, # Внешний ID предложения
        title: "Кредит", # Название предложения (если есть)
        mark: car.brand, # Марка автомобиля
        model: car.model, # Модель автомобиля
        generation: generation&.name || "Не указано", # Поколение автомобиля (если есть)
        bodyType: car.body_type&.name || "Не указано", # Тип кузова
        complectation: car.complectation_name, # Комплектация (если есть)
        engineType: car.engine_name_type&.name || "Не указано", # Тип двигателя
        enginePower: car.engine_power_type&.power || 0, # Мощность двигателя
        engineVolume: car.engine_capacity_type&.capacity || 0, # Объем двигателя
        gearbox: car.gearbox_type&.name || "Не указано", # Тип коробки передач
        wheelDrive: car.drive_type&.name || "Не указано", # Привод
        price: car.price.to_s || 0, # Цена автомобиля
        year: car.year || 0, # Год автомобиля
        run: history_car.last_mileage || 0, # Пробег автомобиля
        vin: history_car.vin, # VIN (если есть)
        color: car.color&.name || "Не указано", # Цвет автомобиля
        owners: history_car&.previous_owners.to_s || "0", # Количество владельцев
        imageUrls: [first_image_url], # URL изображений (если есть)
        category: "cars", # Категория
        offerType: "credit" # Тип предложения (если есть)
      }
    }
  end

  # Builds values for installment application
  #
  # @param [Installment] installment Installment application object
  # @return [Hash] Formatted installment application values
  def build_installment_values(installment)
    car = Car.find(installment.car_id) # Получаем данные о машине по car_id
    history_car = HistoryCar.find_by(car_id: car.id) # Получаем данные о истории машины
    generation = car.model.generations.first # Получаем генерацию через модель
    first_image_url = car.images.first&.url || "Отсутствует изображение"

    {
      clientPhone: installment.phone,
      type: "installment",
      source: {
        dealerId: 77, # Замените на актуальный ID дилера
        websiteId: 627, # Замените на актуальный ID сайта
      },
      dateTime: Time.current.utc.strftime('%Y-%m-%d %H:%M:%S'), # Текущая дата и время
      externalId: installment.id.to_s, # Внешний ID заявки
      values: {
        clientName: installment.name, # Имя клиента
        offerExternalId: installment.id, # ID заявки
        comment: COMMENTS[:installment], # Комментарий
        paymentMethod: "installment", # Метод оплаты
        creditAmount: installment.initial_contribution.to_s, # Сумма кредита
        creditPeriod: installment.credit_term.to_s # Срок кредита
      },
      offer: {
        externalId: installment.id.to_s, # Внешний ID предложения
        title: "Заявка на рассрочку", # Название предложения
        mark: car.brand, # Марка автомобиля
        model: car.model, # Модель автомобиля
        generation: generation&.name || "Не указано", # Название генерации
        bodyType: car.body_type&.name || "Не указано", # Тип кузова
        complectation: car.complectation_name, # Комплектация (если есть)
        engineType: car.engine_name_type&.name || "Не указано", # Тип двигателя
        enginePower: car.engine_power_type&.power || 0, # Мощность двигателя
        engineVolume: car.engine_capacity_type&.capacity || 0, # Объем двигателя
        gearbox: car.gearbox_type&.name || "Не указано", # Тип коробки передач
        wheelDrive: car.drive_type&.name || "Не указано", # Привод
        price: car.price.to_s || 0, # Цена автомобиля
        year: car.year || 0, # Год автомобиля
        run: history_car.last_mileage || 0, # Пробег автомобиля
        vin: history_car.vin, # VIN (если есть)
        color: car.color&.name || "Не указано", # Цвет автомобиля
        owners: history_car&.previous_owners.to_s || "0", # Количество владельцев
        imageUrls: [first_image_url], # URL первой картинки автомобиля
        category: "cars", # Категория
        offerType: "installment" # Тип предложения
      }
    }
  end

  # Builds values for buyout application
  #
  # @param [Buyout] buyout Buyout application object
  # @return [Hash] Formatted buyout application values
  def build_buyout_values(buyout)
    {
      clientPhone: buyout.phone.gsub(/\D/, ''), # Удаляем все нецифровые символы
      type: "buyout",
      source: {
        dealerId: 77,
        websiteId: 627,
      },
      dateTime: Time.current.utc.strftime('%Y-%m-%d %H:%M:%S'), # Текущая дата и время
      externalId: buyout.id.to_s, # Внешний ID заявки
      values: {
        clientName: buyout.name, # Имя клиента
        offerExternalId: buyout.id, # ID заявки
        comment: COMMENTS[:buyout], # Комментарий
        paymentMethod: "buyout", # Метод оплаты
        clientVehicleMark: buyout.brand, # Марка автомобиля
        clientVehicleModel: buyout.model, # Модель автомобиля
        clientVehicleYear: buyout.year.to_s, # Год автомобиля
        clientVehicleRun: buyout.mileage.to_s, # Пробег автомобиля
      },
      offer: {
        externalId: buyout.id.to_s, # Внешний ID предложения
        title: "Заявка на выкуп", # Название предложения
        mark: buyout.brand, # Марка автомобиля
        model: buyout.model, # Модель автомобиля
        year: buyout.year || 0, # Год автомобиля
        run: buyout.mileage || 0, # Пробег автомобиля
        category: "cars", # Категория
        offerType: "buyout" # Тип предложения
      }
    }
  end

  # Builds values for exchange application
  #
  # @param [Exchange] exchange Exchange application object
  # @return [Hash] Formatted exchange application values
  def build_exchange_values(exchange)
    car = Car.find(exchange.car_id) # Получаем данные о машине по car_id
    history_car = HistoryCar.find_by(car_id: car.id) # Получаем данные о истории машины
    generation = car.model.generations.first # Получаем генерацию через модель
    first_image_url = car.images.first&.url || "Отсутствует изображение" # Замените "string" на значение по умолчанию, если изображение отсутствует

    {
      clientPhone: exchange.phone, # Телефон клиента
      type: "exchange",
      source: {
        dealerId: 77,
        websiteId: 627
      },
      dateTime: Time.current.utc.strftime('%Y-%m-%d %H:%M:%S'), # Текущая дата и время
      externalId: exchange.id.to_s, # Внешний ID кредита
      values: {
        clientName: exchange.name, # ФИО клиента
        offerExternalId: exchange.id, # ID кредита
        comment: COMMENTS[:exchange], # Комментарий
        paymentMethod: "exchange", # Метод оплаты
        clientVehicleMark: exchange.customer_car, # Марка автомобиля
        creditAmount: exchange.initial_contribution.to_s, # Сумма кредита
        creditPeriod: exchange.credit_term.to_s # Срок кредита
      },
      offer: {
        externalId: exchange.id.to_s, # Внешний ID предложения
        title: "Trade-in", # Название предложения (если есть)
        mark: car.brand, # Марка автомобиля
        model: car.model, # Модель автомобиля
        generation: generation&.name || "Не указано", # Поколение автомобиля (если есть)
        bodyType: car.body_type&.name || "Не указано", # Тип кузова
        complectation: car.complectation_name, # Комплектация (если есть)
        engineType: car.engine_name_type&.name || "Не указано", # Тип двигателя
        enginePower: car.engine_power_type&.power || 0, # Мощность двигателя
        engineVolume: car.engine_capacity_type&.capacity || 0, # Объем двигателя
        gearbox: car.gearbox_type&.name || "Не указано", # Тип коробки передач
        wheelDrive: car.drive_type&.name || "Не указано", # Привод
        price: car.price.to_s || 0, # Цена автомобиля
        year: car.year || 0, # Год автомобиля
        run: history_car.last_mileage || 0, # Пробег автомобиля
        vin: history_car.vin, # VIN (если есть)
        color: car.color&.name || "Не указано", # Цвет автомобиля
        owners: history_car&.previous_owners.to_s || "0", # Количество владельцев
        imageUrls: [first_image_url], # URL изображений (если есть)
        category: "cars", # Категория
        offerType: "exchange" # Тип предложения (если есть)
      }
    }
  end

  # Builds values for call request application
  #
  # @param [CallRequest] call_request Call request object
  # @return [Hash] Formatted call request values
  def build_call_request_values(call_request)
    car = Car.find(call_request.car_id) # Получаем данные о машине по car_id
    history_car = HistoryCar.find_by(car_id: car.id) # Получаем данные о истории машины
    generation = car.model.generations.first # Получаем генерацию через модель
    first_image_url = car.images.first&.url || "Отсутствует изображение" # Замените "string" на значение по умолчанию, если изображение отсутствует

    {
      clientPhone: call_request.phone, # Телефон клиента
      type: "call_request",
      source: {
        dealerId: 77,
        websiteId: 627
      },
      dateTime: Time.current.utc.strftime('%Y-%m-%d %H:%M:%S'), # Текущая дата и время
      externalId: call_request.id.to_s, # Внешний ID кредита
      values: {
        clientName: call_request.name, # ФИО клиента
        offerExternalId: call_request.id, # ID кредита
        comment: COMMENTS[:call_request].call(call_request),
        paymentMethod: "call_request" # Метод оплаты
      },
      offer: {
        externalId: call_request.id.to_s, # Внешний ID предложения
        title: "Call request", # Название предложения (если есть)
        mark: car.brand, # Марка автомобиля
        model: car.model, # Модель автомобиля
        generation: generation&.name || "Не указано", # Поколение автомобиля (если есть)
        bodyType: car.body_type&.name || "Не указано", # Тип кузова
        complectation: car.complectation_name, # Комплектация (если есть)
        engineType: car.engine_name_type&.name || "Не указано", # Тип двигателя
        enginePower: car.engine_power_type&.power || 0, # Мощность двигателя
        engineVolume: car.engine_capacity_type&.capacity || 0, # Объем двигателя
        gearbox: car.gearbox_type&.name || "Не указано", # Тип коробки передач
        wheelDrive: car.drive_type&.name || "Не указано", # Привод
        price: car.price.to_s || 0, # Цена автомобиля
        year: car.year || 0, # Год автомобиля
        run: history_car.last_mileage || 0, # Пробег автомобиля
        vin: history_car.vin, # VIN (если есть)
        color: car.color&.name || "Не указано", # Цвет автомобиля
        owners: history_car&.previous_owners.to_s || "0", # Количество владельцев
        imageUrls: [first_image_url], # URL изображений (если есть)
        category: "cars", # Категория
        offerType: "call_request" # Тип предложения (если есть)
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
