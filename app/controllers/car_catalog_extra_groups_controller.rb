class CarCatalogExtraGroupsController < ApplicationController
  before_action :set_car_catalog_extra_group, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /car_catalog_extra_groups or /car_catalog_extra_groups.json
  def index
    @car_catalog_extra_groups = CarCatalogExtraGroup.all
    render json: @car_catalog_extra_groups
  end

  # GET /car_catalog_extra_groups/1 or /car_catalog_extra_groups/1.json
  def show
    render json: @car_catalog_extra_group
  end

  def create
    @car_catalog_extra_group = CarCatalogExtraGroup.new(car_catalog_extra_group_params)
    if @car_catalog_extra_group.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra_group, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra_group.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @car_catalog_extra_group.update(car_catalog_extra_group_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra_group, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_extra_group.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if CarCatalogExtra.exists?(car_catalog_extra_group_id: @car_catalog_extra_group.id)
        render json: { error: "Невозможно удалить название комплектациигруппы, так как он используется в таблицах комплектации." }, status: :unprocessable_entity
    else
        if @car_catalog_extra_group.destroy
            head :ok
        else
            render json: @car_catalog_extra_group.errors, status: :unprocessable_entity
        end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_extra_group
      @car_catalog_extra_group = CarCatalogExtraGroup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_extra_group_params
      params.require(:car_catalog_extra_group).permit(:name)
    end
end
