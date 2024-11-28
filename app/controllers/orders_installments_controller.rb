class OrdersInstallmentsController < ApplicationController
  before_action :set_orders_installment, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    service = OrdersInstallmentsService.new(params)
    render json: service.call
  end

  def show
    render json: @orders_installment
  end

  def create
    @orders_installment = OrdersInstallment.new(orders_installment_params)

    if @orders_installment.save
      render json: @orders_installment, status: :created
    else
      render json: @orders_installment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @orders_installment.update(orders_installment_params)
      render json: @orders_installment, status: :ok
    else
      render json: @orders_installment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @orders_installment.destroy
      render status: :ok
    else
      render json: @orders_installment.errors, status: :unprocessable_entity
    end
  end

  private
  def set_orders_installment
    @orders_installment = OrdersInstallment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Рассрочка не найдена' }, status: :not_found
  end
    def orders_installment_params
      params.require(:orders_installment).permit(:installment_id, :order_status_id, :description)
    end
end
