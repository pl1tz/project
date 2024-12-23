class CarCatalogExtraNamesController < ApplicationController
  before_action :set_car_catalog_extra_name, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @car_catalog_extra_names = CarCatalogExtraName.all
    render json: @car_catalog_extra_names, adapter: :json
  end

  def show
    render json: @car_catalog_extra_name
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
    if CarCatalogExtra.exists?(car_catalog_extra_name_id: @car_catalog_extra_name.id)
        render json: { error: "Невозможно удалить название параметр комплектаци, так как он используется в таблицах комплектации." }, status: :unprocessable_entity
    else
        if @car_catalog_extra_name.destroy
            head :ok
        else
            render json: @car_catalog_extra_name.errors, status: :unprocessable_entity
        end
    end
  end

  private
    def set_car_catalog_extra_name
      @car_catalog_extra_name = CarCatalogExtraName.find(params[:id])
    end

    def car_catalog_extra_name_params
      params.require(:car_catalog_extra_name).permit(:name)
    end
end
