class BuyoutsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_buyout, only: %i[ show update destroy ]

  def index
    @buyouts = Buyout.all
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @buyouts
    end
  end

  def show
    render json: @buyout
  end

  def create
    Rails.logger.info "Received params: #{params.inspect}"
    @buyout = Buyout.new(buyout_params)

    if @buyout.save
      render json: create_order_buyout(@buyout), status: :created
    else
      render json: @buyout.errors, status: :unprocessable_entity
    end
  end

  def update
    if @buyout.update(buyout_params)
      render json: @buyout, status: :ok
    else
      render json: @buyout.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @buyout.destroy
      head :ok
    else
      render json: @buyout.errors, status: :unprocessable_entity
    end
  end

  private
    def set_buyout
      @buyout = Buyout.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Выкуп не найден" }, status: :not_found
    end

    def buyout_params
      params.require(:buyout).permit(:name, :phone, :brand, :model, :year, :mileage)
    end

    def create_order_buyout(buyout)
      order_buyout = OrdersBuyout.new(
        buyout_id: buyout.id,
        description: "Выкуп создан и ожидает обработки",
        order_status_id: OrderStatus.find_by(name: "Новая").id
      )
      
      if order_buyout.save
        { buyout: buyout, order_buyout: order_buyout, status: :created }
      else
        { errors: order_buyout.errors, status: :unprocessable_entity }
      end
    end
end
