class CarCatalogExtraNamesController < ApplicationController
  before_action :set_car_catalog_extra_name, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token
  # GET /car_catalog_extra_names or /car_catalog_extra_names.json
  def index
    @car_catalog_extra_names = CarCatalogExtraName.all
    render json: @car_catalog_extras
  end

  # GET /car_catalog_extra_names/1 or /car_catalog_extra_names/1.json
  def show
    render json: @car_catalog_extras
  end

  def create
    @car_catalog_extra_name = CarCatalogExtraName.new(car_catalog_extra_name_params)
    if @car_catalog_extra_name.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra_name, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra_name.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @car_catalog_extra_name.update(car_catalog_extra_name_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra_name, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra_name.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @car_catalog_extra_name.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra_name.errors, status: :internal_server_error
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_extra_name
      @car_catalog_extra_name = CarCatalogExtraName.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_extra_name_params
      params.require(:car_catalog_extra_name).permit(:name)
    end
end
