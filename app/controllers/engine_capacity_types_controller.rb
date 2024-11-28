class EngineCapacityTypesController < ApplicationController
  before_action :set_engine_capacity_type, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @engine_capacity_types = EngineCapacityType.all
    render json: @engine_capacity_types
  end

  def show
    render json: @engine_capacity_type
  end

  def create
    @engine_capacity_type = EngineCapacityType.new(engine_capacity_type_params)

    if @engine_capacity_type.save
      render json: @engine_capacity_type, status: :created
      else
      render json: @engine_capacity_type.errors, status: :unprocessable_entity
    end
  end

  def update
    if @engine_capacity_type.update(engine_capacity_type_params)
      render json: @engine_capacity_type, status: :ok
    else
      render json: @engine_capacity_type.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if Car.exists?(engine_capacity_type_id: @engine_capacity_type.id)
      render json: { error: "Невозможно удалить тип объема двигателя, так как он используется в таблице автомобилей." }, status: :unprocessable_entity
    else
      if @engine_capacity_type.destroy
        head :ok
    else
        render json: @engine_capacity_type.errors, status: :internal_server_error
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_engine_capacity_type
      @engine_capacity_type = EngineCapacityType.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def engine_capacity_type_params
      params.require(:engine_capacity_type).permit(:capacity)
    end
end
