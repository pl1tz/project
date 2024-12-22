class CarCatalogExtraGroupsController < ApplicationController
  before_action :set_car_catalog_extra_group, only: %i[ show edit update destroy ]

  # GET /car_catalog_extra_groups or /car_catalog_extra_groups.json
  def index
    @car_catalog_extra_groups = CarCatalogExtraGroup.all
  end

  # GET /car_catalog_extra_groups/1 or /car_catalog_extra_groups/1.json
  def show
  end

  # GET /car_catalog_extra_groups/new
  def new
    @car_catalog_extra_group = CarCatalogExtraGroup.new
  end

  # GET /car_catalog_extra_groups/1/edit
  def edit
  end

  # POST /car_catalog_extra_groups or /car_catalog_extra_groups.json
  def create
    @car_catalog_extra_group = CarCatalogExtraGroup.new(car_catalog_extra_group_params)

    respond_to do |format|
      if @car_catalog_extra_group.save
        format.html { redirect_to @car_catalog_extra_group, notice: "Car catalog extra group was successfully created." }
        format.json { render :show, status: :created, location: @car_catalog_extra_group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_catalog_extra_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_catalog_extra_groups/1 or /car_catalog_extra_groups/1.json
  def update
    respond_to do |format|
      if @car_catalog_extra_group.update(car_catalog_extra_group_params)
        format.html { redirect_to @car_catalog_extra_group, notice: "Car catalog extra group was successfully updated." }
        format.json { render :show, status: :ok, location: @car_catalog_extra_group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_catalog_extra_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_catalog_extra_groups/1 or /car_catalog_extra_groups/1.json
  def destroy
    @car_catalog_extra_group.destroy!

    respond_to do |format|
      format.html { redirect_to car_catalog_extra_groups_path, status: :see_other, notice: "Car catalog extra group was successfully destroyed." }
      format.json { head :no_content }
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
