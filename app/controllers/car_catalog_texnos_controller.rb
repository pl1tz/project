class CarCatalogTexnosController < ApplicationController
  before_action :set_car_catalog_texno, only: %i[ show edit update destroy ]

  # GET /car_catalog_texnos or /car_catalog_texnos.json
  def index
    @car_catalog_texnos = CarCatalogTexno.all
  end

  # GET /car_catalog_texnos/1 or /car_catalog_texnos/1.json
  def show
  end

  # GET /car_catalog_texnos/new
  def new
    @car_catalog_texno = CarCatalogTexno.new
  end

  # GET /car_catalog_texnos/1/edit
  def edit
  end

  # POST /car_catalog_texnos or /car_catalog_texnos.json
  def create
    @car_catalog_texno = CarCatalogTexno.new(car_catalog_texno_params)

    respond_to do |format|
      if @car_catalog_texno.save
        format.html { redirect_to @car_catalog_texno, notice: "Car catalog texno was successfully created." }
        format.json { render :show, status: :created, location: @car_catalog_texno }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_catalog_texno.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_catalog_texnos/1 or /car_catalog_texnos/1.json
  def update
    respond_to do |format|
      if @car_catalog_texno.update(car_catalog_texno_params)
        format.html { redirect_to @car_catalog_texno, notice: "Car catalog texno was successfully updated." }
        format.json { render :show, status: :ok, location: @car_catalog_texno }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_catalog_texno.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_catalog_texnos/1 or /car_catalog_texnos/1.json
  def destroy
    @car_catalog_texno.destroy!

    respond_to do |format|
      format.html { redirect_to car_catalog_texnos_path, status: :see_other, notice: "Car catalog texno was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_texno
      @car_catalog_texno = CarCatalogTexno.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_texno_params
      params.require(:car_catalog_texno).permit(:image, :width, :height, :length)
    end
end
