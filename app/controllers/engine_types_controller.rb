class EngineTypesController < ApplicationController
  before_action :set_engine_type, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @engine_types = EngineType.all 
    render json: @engine_types
  end

  def show
    render json: @engine_type
  end

  def create
    @engine_type = EngineType.new(engine_type_params)

    if @engine_type.save
      render json: @engine_type, status: :created
    else
      render json: @engine_type.errors, status: :unprocessable_entity
    end
  end       

  def update
    if @engine_type.update(engine_type_params)
      render json: @engine_type, status: :ok
    else
      render json: @engine_type.errors, status: :unprocessable_entity
    end
  end   

  def destroy
    if Car.exists?(engine_type_id: @engine_type.id)
      render json: { error: "Невозможно удалить тип двигателя, так как он используется в таблице автомобилей." }, status: :unprocessable_entity
    else
      if @engine_type.destroy
        head :ok
      else
        render json: @engine_type.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_engine_type
      @engine_type = EngineType.find(params[:id])
    end

    def engine_type_params
      params.require(:engine_type).permit(:name, :engine_power, :engine_capacity)
    end
end
