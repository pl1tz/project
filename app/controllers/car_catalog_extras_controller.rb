class CarCatalogExtrasController < ApplicationController
  before_action :set_car_catalog_extra, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token
  # GET /car_catalog_extras or /car_catalog_extras.json
  def index
    per_page = 18
    @car_catalog_extras = CarCatalogExtra.page(params[:page]).per(per_page)
    render json: @car_catalog_extras, adapter: :json
  end

  # GET /car_catalog_extras/1 or /car_catalog_extras/1.json
  def show
    render json: @car_catalog_extra
  end

  def create
    @car_catalog_extra = CarCatalogExtra.new(car_catalog_extra_params)
    if @car_catalog_extra.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @car_catalog_extra.update(car_catalog_extra_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @car_catalog_extra.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra.errors, status: :internal_server_error
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_extra
      @car_catalog_extra = CarCatalogExtra.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_extra_params
      params.require(:car_catalog_extra).permit(:car_catalog_configuration_id, :car_catalog_extra_group_id, :car_catalog_extra_name_id)
    end
end
