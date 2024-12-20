class CarCatalogEnginesController < ApplicationController
  before_action :set_car_catalog_engine, only: %i[ show edit update destroy ]

  # GET /car_catalog_engines or /car_catalog_engines.json
  def index
    @car_catalog_engines = CarCatalogEngine.all
  end

  # GET /car_catalog_engines/1 or /car_catalog_engines/1.json
  def show
  end

  # GET /car_catalog_engines/new
  def new
    @car_catalog_engine = CarCatalogEngine.new
  end

  # GET /car_catalog_engines/1/edit
  def edit
  end

  # POST /car_catalog_engines or /car_catalog_engines.json
  def create
    @car_catalog_engine = CarCatalogEngine.new(car_catalog_engine_params)

    respond_to do |format|
      if @car_catalog_engine.save
        format.html { redirect_to @car_catalog_engine, notice: "Car catalog engine was successfully created." }
        format.json { render :show, status: :created, location: @car_catalog_engine }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_catalog_engine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_catalog_engines/1 or /car_catalog_engines/1.json
  def update
    respond_to do |format|
      if @car_catalog_engine.update(car_catalog_engine_params)
        format.html { redirect_to @car_catalog_engine, notice: "Car catalog engine was successfully updated." }
        format.json { render :show, status: :ok, location: @car_catalog_engine }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_catalog_engine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_catalog_engines/1 or /car_catalog_engines/1.json
  def destroy
    @car_catalog_engine.destroy!

    respond_to do |format|
      format.html { redirect_to car_catalog_engines_path, status: :see_other, notice: "Car catalog engine was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_engine
      @car_catalog_engine = CarCatalogEngine.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_engine_params
      params.require(:car_catalog_engine).permit(:car_catalog_id, :name_engines, :torque, :power, :cylinders, :engine_volume, :fuel_type, :engine_type)
    end
end
