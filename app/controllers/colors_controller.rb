class ColorsController < ApplicationController
  before_action :set_color, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @colors = Color.all 
    render json: @colors
  end

  def show
    render json: @color
  end

  def create
    @color = Color.new(color_params)

    if @color.save  
      render json: @color, status: :created
    else
      render json: @color.errors, status: :unprocessable_entity
    end       
  end

  def update
    if @color.update(color_params)
      render json: @color, status: :ok
    else
      render json: @color.errors, status: :unprocessable_entity
    end 
  end

  def destroy
    if Car.exists?(color_id: @color.id)
      render json: { error: "Невозможно удалить цвет, так как он используется в таблице автомобилей." }, status: :unprocessable_entity
    else
      if @color.destroy
        head :ok
      else
        render json: @color.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_color
      @color = Color.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Цвет не найден." }, status: :not_found
    end

    def color_params
      params.require(:color).permit(:name)
    end
end
