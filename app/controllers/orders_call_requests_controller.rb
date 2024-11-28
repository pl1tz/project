class OrdersCallRequestsController < ApplicationController
  before_action :set_orders_call_request, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    service = OrdersCallRequestsService.new(params)
    render json: service.call
  end
  

  def show
    render json: @orders_call_request
  end


  def create
    @orders_call_request = OrdersCallRequest.new(orders_call_request_params)

    if @orders_call_request.save
      render json: @orders_call_request, status: :created
    else
      render json: @orders_call_request.errors, status: :unprocessable_entity
    end
  end
    
  def update
    if @orders_call_request.update(orders_call_request_params)
      render json: @orders_call_request, status: :ok
    else
      render json: @orders_call_request.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @orders_call_request.destroy!
      head :ok
    else
      render json: @orders_call_request.errors, status: :unprocessable_entity
    end
  end

  private
  def set_orders_call_request
    @orders_call_request = OrdersCallRequest.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Заказ не найден' }, status: :not_found
  end
    def orders_call_request_params
      params.require(:orders_call_request).permit(:call_request_id, :order_status_id, :description)
    end
end
