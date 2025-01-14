class CallRequestsController < ApplicationController
  before_action :set_call_request, only: %i[ show update destroy ]
  protect_from_forgery with: :null_session

  def index
    @call_requests = CallRequest.all
    render json: @call_requests
  end

  def show
    render json: @call_request
  end


  def create
    Rails.logger.info "Received params: #{params.inspect}"
    @call_request = CallRequest.new(call_request_params)

    ActiveRecord::Base.transaction do
      if @call_request.save
        crm_service = PlexCrmService.new(request)
        crm_response = crm_service.send_call_request_application(@call_request)
        
        Rails.logger.info "CRM Response: #{crm_response.inspect}"
        
        unless crm_response[:success]
          error_message = "Failed to send to CRM: #{crm_response[:message]}"
          Rails.logger.error error_message
          raise ActiveRecord::Rollback, error_message
        end

        Rails.logger.info "Successfully created call request and sent to CRM"
        create_order_call_request(@call_request)
      else
        Rails.logger.error "Failed to save call request: #{@call_request.errors.full_messages}"
        render json: @call_request.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::Rollback => e
    render json: { error: e.message || "Failed to create call request" }, 
           status: :unprocessable_entity
  end

  def update
    if @call_request.update(call_request_params)
      render json: @call_request, status: :ok
    else
      render json: @call_request.errors, status: :unprocessable_entity
    end
  end   

  def destroy
    if @call_request.destroy
      head :ok
    else
      render json: @call_request.errors, status: :unprocessable_entity
    end
  end

  private
    def set_call_request
      @call_request = CallRequest.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Заявка не найдена' }, status: :not_found
    end

    

    def call_request_params
      params.require(:call_request).permit(:car_id, :name, :phone, :preferred_time) # car_id остается, но не обязательно
    end

    def create_order_call_request(call_request)
      order_call_request = OrdersCallRequest.new(
        call_request_id: call_request.id,
        description: "Заявка создана и ожидает обработки",
        order_status_id: OrderStatus.find_by(name: "Новая").id
      )
      
      if order_call_request.save
        render json: { call_request: call_request, order_call_request: order_call_request}, status: :created
      else
        render json: { errors: order_call_request.errors}, status: :unprocessable_entity
      end
    end
end
