class OrderStatusesController < ApplicationController
  before_action :set_order_status, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @order_statuses = OrderStatus.all
    render json: @order_statuses
  end

  def show
    render json: @order_status
  end

  def create
    @order_status = OrderStatus.new(order_status_params)

    if @order_status.save
      render json: @order_status, status: :created
    else
      render json: @order_status.errors, status: :unprocessable_entity
    end
  end

  def update
    if @order_status.update(order_status_params)
      render json: @order_status, status: :ok
    else
      render json: @order_status.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @order_status.destroy!
      head :ok
    else
      render json: @order_status.errors, status: :internal_server_error
    end
  end

  private
    def set_order_status
      @order_status = OrderStatus.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Статус заказа не найден." }, status: :not_found
    end

    def order_status_params
      params.require(:order_status).permit(:name)
    end
end
