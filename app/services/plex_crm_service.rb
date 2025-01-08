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
    @token = 'ezo4ysJQm1r1ZiFsFxBtp7zOV5rYAgYY9o3RWkz325009358'
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
      websiteId: 628
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
    {
      clientName: credit.name,
      clientPhone: credit.phone,
      creditInitialFee: credit.initial_contribution,
      creditPeriod: credit.credit_term,
      bankTitle: credit.bank&.name,
      comment: COMMENTS[:credit]
    }
  end

  # Builds values for installment application
  #
  # @param [Installment] installment Installment application object
  # @return [Hash] Formatted installment application values
  def build_installment_values(installment)
    {
      clientName: installment.name,
      clientPhone: installment.phone,
      creditInitialFee: installment.initial_contribution,
      creditPeriod: installment.credit_term,
      comment: COMMENTS[:installment]
    }
  end

  # Builds values for buyout application
  #
  # @param [Buyout] buyout Buyout application object
  # @return [Hash] Formatted buyout application values
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

  # Builds values for exchange application
  #
  # @param [Exchange] exchange Exchange application object
  # @return [Hash] Formatted exchange application values
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

  # Builds values for call request application
  #
  # @param [CallRequest] call_request Call request object
  # @return [Hash] Formatted call request values
  def build_call_request_values(call_request)
    {
      clientName: call_request.name,
      clientPhone: call_request.phone,
      comment: COMMENTS[:call_request].call(call_request)
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
