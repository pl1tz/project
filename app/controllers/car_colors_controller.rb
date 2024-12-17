class CarColorsController < ApplicationController
  before_action :set_car_color, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /car_colors or /car_colors.json
  def index
    @car_colors = CarColor.all
    render json: @car_colors
  end

  # POST /car_colors or /car_colors.json
  def create
    @car_color = CarColor.new(car_color_params)
    if @car_color.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_color, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_color.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /car_colors/1 or /car_colors/1.json
  def update
    if @car_color.update(car_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_color, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_color.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /car_colors/1 or /car_colors/1.json
  def destroy
    if @car_color.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car_color.errors, status: :internal_server_error
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_color
      @car_color = car_color.find_by(id: params[:id])
      if @car_color.nil?
        render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
      end
    end

    # Only allow a list of trusted parameters through.
    def car_color_params
      params.require(:car_color).permit(:carcatalog_id, :background, :name, :image)
    end
end
