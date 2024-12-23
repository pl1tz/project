class CarCatalogTexnosController < ApplicationController
  before_action :set_car_catalog_texno, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /car_catalog_texnos or /car_catalog_texnos.json
  def index
    @car_catalog_texnos = CarCatalogTexno.all
    render json: @car_catalog_texnos
  end

  # GET /car_catalog_texnos/1 or /car_catalog_texnos/1.json
  def show
    render json: @car_catalog_texno
  end

  def create
    @car_catalog_texno = CarCatalogTexno.new(car_catalog_texno_params)
    if @car_catalog_texno.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_texno, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_texno.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @car_catalog_texno.update(car_catalog_texno_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_texno, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_texno.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @car_catalog_texno.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_catalog_texno.errors, status: :internal_server_error
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_texno
      @car_catalog_texno = CarCatalogTexno.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_texno_params
      params.require(:car_catalog_texno).permit(:car_catalog_id,:image, :width, :height, :length)
    end
end
