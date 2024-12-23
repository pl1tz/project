class CarCatalogConfigurationsController < ApplicationController
  before_action :set_car_catalog_configuration, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token
  # GET /car_catalog_configurations or /car_catalog_configurations.json
  def index
    @car_catalog_configurations = CarCatalogConfiguration.all
    render json: @car_catalog_configurations
  end

  # GET /car_catalog_configurations/1 or /car_catalog_configurations/1.json
  def show
    render json: @car_catalog_configurations
  end

  def create
    @car_catalog_configuration = CarCatalogConfiguration.new(car_catalog_configuration_params)
    if @car_catalog_configuration.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_configuration, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_configuration.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @car_catalog_configuration.update(car_catalog_configuration_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_configuration, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_configuration.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @car_catalog_configuration.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_configuration.errors, status: :internal_server_error
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_configuration
      @car_catalog_configuration = CarCatalogConfiguration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_configuration_params
      params.require(:car_catalog_configuration).permit(:car_catalog_id, :package_group, :package_name, :volume, :transmission, :power, :price, :credit_discount, :trade_in_discount, :recycling_discount, :special_price)
    end
end
