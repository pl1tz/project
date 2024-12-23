class CarCatalogOrdersController < ApplicationController
  before_action :set_car_catalog_order, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /car_catalog_orders or /car_catalog_orders.json
  def index
    @car_catalog_orders = CarCatalogOrderService.all_orders_with_car_details
    render json: @car_catalog_orders
  end

  # GET /car_catalog_orders/1 or /car_catalog_orders/1.json
  def show
    car_catalog_order = CarCatalogOrderService.order_with_car_details(params[:id])
    if car_catalog_order
      render json: car_catalog_order
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  # POST /car_catalog_orders or /car_catalog_orders.json
  def create
    @car_catalog_order = CarCatalogOrder.new(car_catalog_order_params)
    if @car_catalog_order.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_order, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_order.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /car_catalog_orders/1 or /car_catalog_orders/1.json
  def update
    if @car_catalog_order.update(car_catalog_order_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_order, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_order.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /car_catalog_orders/1 or /car_catalog_orders/1.json
  def destroy
    if @car_catalog_order.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_order.errors, status: :internal_server_error
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_order
      @car_catalog_order = CarCatalogOrder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_order_params
      params.require(:car_catalog_order).permit(:order_status_id, :car_catalog, :name, :phone)
    end
end
