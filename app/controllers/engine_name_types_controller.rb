class EngineNameTypesController < ApplicationController
  before_action :set_engine_name_type, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @engine_name_types = EngineNameType.all
    render json: @engine_name_types
  end

  def show
    render json: @engine_name_type
  end

  def create
    @engine_name_type = EngineNameType.new(engine_name_type_params)

    if @engine_name_type.save
      render json: @engine_name_type, status: :created
    else
      render json: @engine_name_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /engine_name_types/1 or /engine_name_types/1.json
  def update
    if @engine_name_type.update(engine_name_type_params)
      render json: @engine_name_type, status: :ok
    else
      render json: @engine_name_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /engine_name_types/1 or /engine_name_types/1.json
  def destroy
    if Car.exists?(engine_name_type_id: @engine_name_type.id)
      render json: { error: "Невозможно удалить тип названия двигателя, так как он используется в таблице автомобилей." }, status: :unprocessable_entity
    else
      if @engine_name_type.destroy
        head :ok
    else
        render json: @engine_name_type.errors, status: :internal_server_error
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_engine_name_type
      @engine_name_type = EngineNameType.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def engine_name_type_params
      params.require(:engine_name_type).permit(:name)
    end
end
