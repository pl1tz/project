class CarCatalogsController < ApplicationController
  before_action :set_car_catalog, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /car_catalogs or /car_catalogs.json
  def index
    @car_catalogs = CarCatalog.all
    render json: @car_catalogs
  end

  # GET /car_catalogs/1 or /car_catalogs/1.json
  def show
    if @car_catalog.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
      return
    end

    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @car_catalog
    end
  end

  def create
    @car_catalog = CarCatalog.new(car_params)
    if @car_catalog.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /car_catalogs/1 or /car_catalogs/1.json
  def update
    if @car_catalog.update(car_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @car_catalog.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog.errors, status: :internal_server_error
      end
    end
  end

  def all_catalog
    result = CarCatalogService.all_catalog
    render json: result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog
      @car_catalog = CarCatalog.find_by(id: params[:id])
      if @car_catalog.nil?
        render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
      end
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_params
      params.require(:car_catalog).permit(:brand, :model, :power, :acceleration, :consumption, :max_speed)
    end
end
