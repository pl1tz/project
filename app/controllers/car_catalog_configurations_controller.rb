class CarCatalogConfigurationsController < ApplicationController
  before_action :set_car_catalog_configuration, only: %i[ show edit update destroy ]

  # GET /car_catalog_configurations or /car_catalog_configurations.json
  def index
    @car_catalog_configurations = CarCatalogConfiguration.all
  end

  # GET /car_catalog_configurations/1 or /car_catalog_configurations/1.json
  def show
  end

  # GET /car_catalog_configurations/new
  def new
    @car_catalog_configuration = CarCatalogConfiguration.new
  end

  # GET /car_catalog_configurations/1/edit
  def edit
  end

  # POST /car_catalog_configurations or /car_catalog_configurations.json
  def create
    @car_catalog_configuration = CarCatalogConfiguration.new(car_catalog_configuration_params)

    respond_to do |format|
      if @car_catalog_configuration.save
        format.html { redirect_to @car_catalog_configuration, notice: "Car catalog configuration was successfully created." }
        format.json { render :show, status: :created, location: @car_catalog_configuration }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_catalog_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_catalog_configurations/1 or /car_catalog_configurations/1.json
  def update
    respond_to do |format|
      if @car_catalog_configuration.update(car_catalog_configuration_params)
        format.html { redirect_to @car_catalog_configuration, notice: "Car catalog configuration was successfully updated." }
        format.json { render :show, status: :ok, location: @car_catalog_configuration }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_catalog_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_catalog_configurations/1 or /car_catalog_configurations/1.json
  def destroy
    @car_catalog_configuration.destroy!

    respond_to do |format|
      format.html { redirect_to car_catalog_configurations_path, status: :see_other, notice: "Car catalog configuration was successfully destroyed." }
      format.json { head :no_content }
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
