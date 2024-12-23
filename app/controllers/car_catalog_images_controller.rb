class CarCatalogImagesController < ApplicationController
  before_action :set_car_catalog_image, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /car_catalog_images or /car_catalog_images.json
  def index
    @car_catalog_images = CarCatalogImage.all
    render json: @car_catalog_images
  end

  # GET /car_catalog_images/1 or /car_catalog_images/1.json
  def show
    render json: @car_catalog_image
  end
  def show
    result = CarCatalogImage.find(params[:id])
    if result.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
      return
    end

    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: result
    end
  end
  def create
    @car_catalog_image = CarCatalogImage.new(car_catalog_image_params)
    if @car_catalog_image.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_image, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_image.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @car_catalog_image.update(car_catalog_image_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_image, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_image.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /car_catalog_images/1 or /car_catalog_images/1.json
  def destroy
    if @car_catalog_image.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_image.errors, status: :internal_server_error
      end
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
