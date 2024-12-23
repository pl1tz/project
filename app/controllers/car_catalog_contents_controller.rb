class CarCatalogContentsController < ApplicationController
  before_action :set_car_catalog_content, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /car_catalog_contents or /car_catalog_contents.json
  def index
    @car_catalog_contents = CarCatalogContent.all
    render json: @car_catalog_contents
  end

  # GET /car_catalog_contents/1 or /car_catalog_contents/1.json
  def show
    render json: @car_catalog_content
  end

  def create
    @car_catalog_content = CarCatalogContent.new(car_catalog_content_params)
    if @car_catalog_content.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_content, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_content.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @car_catalog_content.update(car_catalog_content_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_content, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_content.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @car_catalog_content.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_content.errors, status: :internal_server_error
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_content
      @car_catalog_content = CarCatalogContent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_content_params
      params.require(:car_catalog_content).permit(:car_catalog_id, :content)
    end
end
