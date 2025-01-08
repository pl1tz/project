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

  def initialize
    @token = 'ezo4ysJQm1r1ZiFsFxBtp7zOV5rYAgYY9o3RWkz325009358'
    @headers = {
      'Authorization' => "Bearer #{@token}",
      'Accept' => 'application/json'
    }
  end

  # Generic method for sending applications to Plex CRM
  #
  # @param [Symbol] type Type of application (:credit, :installment, :buyout, :exchange, :call_request)
  # @param [Object] application Application object
  # @return [Hash] Response from the API
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

  def build_request(type, application)
    {
      type: APPLICATION_TYPES[type],
      source: source_params,
      dateTime: Time.current.utc.strftime('%Y-%m-%d %H:%M:%S'),
      values: send("build_#{type}_values", application)
    }
  end

  def source_params
    {
      dealerId: 77,
      websiteId: 628
    }
  end

  def build_credit_values(credit)
    {
      clientName: credit.name,
      clientPhone: credit.phone,
      creditInitialFee: credit.initial_contribution,
      creditPeriod: credit.credit_term,
      bankTitle: credit.bank&.name,
      comment: COMMENTS[:credit]
    }
  end

  def build_installment_values(installment)
    {
      clientName: installment.name,
      clientPhone: installment.phone,
      creditInitialFee: installment.initial_contribution,
      creditPeriod: installment.credit_term,
      comment: COMMENTS[:installment]
    }
  end

  def build_buyout_values(buyout)
    {
      clientName: buyout.name,
      clientPhone: buyout.phone,
      clientVehicleMark: buyout.brand,
      clientVehicleModel: buyout.model,
      clientVehicleYear: buyout.year,
      clientVehicleRun: buyout.mileage,
      comment: COMMENTS[:buyout]
    }
  end

  def build_exchange_values(exchange)
    {
      clientName: exchange.name,
      clientPhone: exchange.phone,
      creditInitialFee: exchange.initial_contribution,
      creditPeriod: exchange.credit_term,
      clientVehicleOfferUrl: exchange.customer_car,
      comment: COMMENTS[:exchange]
    }
  end

  def build_call_request_values(call_request)
    {
      clientName: call_request.name,
      clientPhone: call_request.phone,
      comment: COMMENTS[:call_request].call(call_request)
    }
  end

  def log_request(type, payload)
    Rails.logger.info "Sending #{type} request to Plex CRM:"
    Rails.logger.info "URL: #{self.class.base_uri}/contact/form"
    Rails.logger.info "Headers: #{@headers}"
    Rails.logger.info "Payload: #{payload}"
  end

  def log_response(response)
    Rails.logger.info "Response from Plex CRM:"
    Rails.logger.info "Status: #{response.code}"
  end

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