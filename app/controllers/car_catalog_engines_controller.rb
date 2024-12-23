class CarCatalogEnginesController < ApplicationController
  before_action :set_car_catalog_engine, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /car_catalog_engines or /car_catalog_engines.json
  def index
    @car_catalog_engines = CarCatalogEngine.all
    render json: @car_catalog_engines
  end

  # GET /car_catalog_engines/1 or /car_catalog_engines/1.json
  def show
    render json: @car_catalog_engines
  end

  def create
    @car_catalog_engine = CarCatalogEngine.new(car_catalog_engine_params)
    if @car_catalog_engine.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_engine, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_engine.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @car_catalog_engine.update(car_catalog_engine_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_engine, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_engine.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @car_catalog_engine.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_engine.errors, status: :internal_server_error
      end
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
