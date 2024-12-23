class CarCatalogOrdersController < ApplicationController
  before_action :set_car_catalog_order, only: %i[ show edit update destroy ]

  # GET /car_catalog_orders or /car_catalog_orders.json
  def index
    @car_catalog_orders = CarCatalogOrder.all
  end

  # GET /car_catalog_orders/1 or /car_catalog_orders/1.json
  def show
  end

  # GET /car_catalog_orders/new
  def new
    @car_catalog_order = CarCatalogOrder.new
  end

  # GET /car_catalog_orders/1/edit
  def edit
  end

  # POST /car_catalog_orders or /car_catalog_orders.json
  def create
    @car_catalog_order = CarCatalogOrder.new(car_catalog_order_params)

    respond_to do |format|
      if @car_catalog_order.save
        format.html { redirect_to @car_catalog_order, notice: "Car catalog order was successfully created." }
        format.json { render :show, status: :created, location: @car_catalog_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_catalog_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_catalog_orders/1 or /car_catalog_orders/1.json
  def update
    respond_to do |format|
      if @car_catalog_order.update(car_catalog_order_params)
        format.html { redirect_to @car_catalog_order, notice: "Car catalog order was successfully updated." }
        format.json { render :show, status: :ok, location: @car_catalog_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_catalog_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_catalog_orders/1 or /car_catalog_orders/1.json
  def destroy
    @car_catalog_order.destroy!

    respond_to do |format|
      format.html { redirect_to car_catalog_orders_path, status: :see_other, notice: "Car catalog order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_order
      @car_catalog_order = CarCatalogOrder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_order_params
      params.require(:car_catalog_order).permit(:car_catalog_id, :name, :phone)
    end
end
