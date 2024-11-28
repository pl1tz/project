class GenerationsController < ApplicationController
  before_action :set_generation, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    @generations = Generation.all
    render json: @generations
  end

  def show
    render json: @generation
  end

  def create
    @generation = Generation.new(generation_params)

    if @generation.save 
      render json: @generation, status: :created
    else
      render json: @generation.errors, status: :unprocessable_entity
    end
  end

  def update
    if @generation.update(generation_params)
      render json: @generation, status: :ok
    else
      render json: @generation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if Car.exists?(generation_id: @generation.id) || Model.exists?(generation_id: @generation.id)
      render json: { error: "Невозможно удалить поколение, так как оно используется в таблице автомобилей или моделей." }, status: :unprocessable_entity
    else
      if @generation.destroy
        head :ok
    else
        render json: @generation.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_generation
      @generation = Generation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Поколение не найдено." }, status: :not_found
    end

    def generation_params
      params.require(:generation).permit(:name, :start_date, :end_date, :model_id)
    end
end
