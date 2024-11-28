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
    @call_request = CallRequest.new(call_request_params)
    if @call_request.save
      result = create_order_call_request(@call_request)
      if result[:errors]
        render json: { call_request: @call_request, errors: result[:errors] }, status: result[:status]
      else
        render json: { call_request: @call_request, order_call_request: result[:order_call_request] }, status: result[:status]
      end
    else
      render json: @call_request.errors, status: :unprocessable_entity
    end 
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
        { call_request: call_request, order_call_request: order_call_request, status: :created }
      else
        { errors: order_call_request.errors, status: :unprocessable_entity }
      end
    end
end
