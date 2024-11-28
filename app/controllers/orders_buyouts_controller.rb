class OrdersBuyoutsController < ApplicationController
  before_action :set_orders_buyout, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @orders_buyouts = OrdersBuyout.all
    render json: @orders_buyouts
  end

  def show
    render json: @orders_buyout
  end

  def create
    @orders_buyout = OrdersBuyout.new(orders_buyout_params)

    if @orders_buyout.save
      render json: @orders_buyout, status: :created
    else
      render json: @orders_buyout.errors, status: :unprocessable_entity
    end
  end

  def update
    if @orders_buyout.update(orders_buyout_params)
      render json: @orders_buyout, status: :ok
    else
      render json: @orders_buyout.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @orders_buyout.destroy!
      render status: :ok
    else
      render json: @orders_buyout.errors, status: :unprocessable_entity
    end
  end

  private
    def set_orders_buyout
      @orders_buyout = OrdersBuyout.find(params[:id])
    end

    def orders_buyout_params
      params.require(:orders_buyout).permit(:buyout_id, :order_status_id, :description)
    end
end
