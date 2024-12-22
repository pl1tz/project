class CarCatalogExtraNamesController < ApplicationController
  before_action :set_car_catalog_extra_name, only: %i[ show edit update destroy ]

  # GET /car_catalog_extra_names or /car_catalog_extra_names.json
  def index
    @car_catalog_extra_names = CarCatalogExtraName.all
  end

  # GET /car_catalog_extra_names/1 or /car_catalog_extra_names/1.json
  def show
  end

  # GET /car_catalog_extra_names/new
  def new
    @car_catalog_extra_name = CarCatalogExtraName.new
  end

  # GET /car_catalog_extra_names/1/edit
  def edit
  end

  # POST /car_catalog_extra_names or /car_catalog_extra_names.json
  def create
    @car_catalog_extra_name = CarCatalogExtraName.new(car_catalog_extra_name_params)

    respond_to do |format|
      if @car_catalog_extra_name.save
        format.html { redirect_to @car_catalog_extra_name, notice: "Car catalog extra name was successfully created." }
        format.json { render :show, status: :created, location: @car_catalog_extra_name }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_catalog_extra_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_catalog_extra_names/1 or /car_catalog_extra_names/1.json
  def update
    respond_to do |format|
      if @car_catalog_extra_name.update(car_catalog_extra_name_params)
        format.html { redirect_to @car_catalog_extra_name, notice: "Car catalog extra name was successfully updated." }
        format.json { render :show, status: :ok, location: @car_catalog_extra_name }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_catalog_extra_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_catalog_extra_names/1 or /car_catalog_extra_names/1.json
  def destroy
    @car_catalog_extra_name.destroy!

    respond_to do |format|
      format.html { redirect_to car_catalog_extra_names_path, status: :see_other, notice: "Car catalog extra name was successfully destroyed." }
      format.json { head :no_content }
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
