class ExchangesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_exchange, only: %i[ show update destroy ]

  def index
    @exchanges = Exchange.all
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @exchanges
    end
  end

  def show
    render json: @exchange
  end
    
  def create
    Rails.logger.info "Received params: #{params.inspect}"
    @exchange = Exchange.new(exchange_params)

    if @exchange.save
      create_order_exchange(@exchange)
    else
      render json: @exchange.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /exchanges/1 or /exchanges/1.json
  def update
    if @exchange.update(exchange_params)
      render json: @exchange, status: :ok
    else
      render json: @exchange.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @exchange.destroy
      head :ok
    else
      render json: @exchange.errors, status: :unprocessable_entity
    end
  end

  private
    def set_exchange
      @exchange = Exchange.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Trade-in не найден" }, status: :not_found
    end

    def exchange_params
      params.require(:exchange).permit(:car_id, :customer_car, :name, :phone, :credit_term, :initial_contribution)
    end

    def create_order_exchange(exchange)
      order_exchange = OrdersExchange.new(
        exchange_id: exchange.id,
        description: "Обмен создан и ожидает обработки",
        order_status_id: OrderStatus.find_by(name: "Новая").id
      )
      if order_exchange.save
        render json: { exchange: exchange, order_exchange: order_exchange }, status: :created
      else
        render json: { exchange: exchange, errors: order_exchange.errors }, status: :unprocessable_entity
      end
    end
end
