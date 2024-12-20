class CarCatalogImagesController < ApplicationController
  before_action :set_car_catalog_image, only: %i[ show edit update destroy ]

  # GET /car_catalog_images or /car_catalog_images.json
  def index
    @car_catalog_images = CarCatalogImage.all
  end

  # GET /car_catalog_images/1 or /car_catalog_images/1.json
  def show
  end

  # GET /car_catalog_images/new
  def new
    @car_catalog_image = CarCatalogImage.new
  end

  # GET /car_catalog_images/1/edit
  def edit
  end

  # POST /car_catalog_images or /car_catalog_images.json
  def create
    @car_catalog_image = CarCatalogImage.new(car_catalog_image_params)

    respond_to do |format|
      if @car_catalog_image.save
        format.html { redirect_to @car_catalog_image, notice: "Car catalog image was successfully created." }
        format.json { render :show, status: :created, location: @car_catalog_image }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_catalog_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_catalog_images/1 or /car_catalog_images/1.json
  def update
    respond_to do |format|
      if @car_catalog_image.update(car_catalog_image_params)
        format.html { redirect_to @car_catalog_image, notice: "Car catalog image was successfully updated." }
        format.json { render :show, status: :ok, location: @car_catalog_image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_catalog_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_catalog_images/1 or /car_catalog_images/1.json
  def destroy
    @car_catalog_image.destroy!

    respond_to do |format|
      format.html { redirect_to car_catalog_images_path, status: :see_other, notice: "Car catalog image was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_image
      @car_catalog_image = CarCatalogImage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_image_params
      params.require(:car_catalog_image).permit(:car_catalog_id, :url)
    end
end
