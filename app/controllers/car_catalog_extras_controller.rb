class CarCatalogExtrasController < ApplicationController
  before_action :set_car_catalog_extra, only: %i[ show edit update destroy ]

  # GET /car_catalog_extras or /car_catalog_extras.json
  def index
    @car_catalog_extras = CarCatalogExtra.all
  end

  # GET /car_catalog_extras/1 or /car_catalog_extras/1.json
  def show
  end

  # GET /car_catalog_extras/new
  def new
    @car_catalog_extra = CarCatalogExtra.new
  end

  # GET /car_catalog_extras/1/edit
  def edit
  end

  # POST /car_catalog_extras or /car_catalog_extras.json
  def create
    @car_catalog_extra = CarCatalogExtra.new(car_catalog_extra_params)

    respond_to do |format|
      if @car_catalog_extra.save
        format.html { redirect_to @car_catalog_extra, notice: "Car catalog extra was successfully created." }
        format.json { render :show, status: :created, location: @car_catalog_extra }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_catalog_extra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_catalog_extras/1 or /car_catalog_extras/1.json
  def update
    respond_to do |format|
      if @car_catalog_extra.update(car_catalog_extra_params)
        format.html { redirect_to @car_catalog_extra, notice: "Car catalog extra was successfully updated." }
        format.json { render :show, status: :ok, location: @car_catalog_extra }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_catalog_extra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_catalog_extras/1 or /car_catalog_extras/1.json
  def destroy
    @car_catalog_extra.destroy!

    respond_to do |format|
      format.html { redirect_to car_catalog_extras_path, status: :see_other, notice: "Car catalog extra was successfully destroyed." }
      format.json { head :no_content }
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
