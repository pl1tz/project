class GearboxTypesController < ApplicationController
  before_action :set_gearbox_type, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @gearbox_types = GearboxType.all  
    render json: @gearbox_types
  end

  def show  
    render json: @gearbox_type
  end

  def create
    @gearbox_type = GearboxType.new(gearbox_type_params)

    if @gearbox_type.save
      render json: @gearbox_type, status: :created
    else
      render json: @gearbox_type.errors, status: :unprocessable_entity
    end
  end

  def update  
    if @gearbox_type.update(gearbox_type_params)
      render json: @gearbox_type, status: :ok
    else
      render json: @gearbox_type.errors, status: :unprocessable_entity
    end
  end   

  def destroy
    # Проверяем, есть ли связи с таблицей cars
    if Car.exists?(gearbox_type_id: @gearbox_type.id)
      render json: { error: "Невозможно удалить тип коробки передач, так как он используется в таблице автомобилей." }, status: :unprocessable_entity
    else
      if @gearbox_type.destroy
        head :ok
      else
        render json: @gearbox_type.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_gearbox_type
      @gearbox_type = GearboxType.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Тип коробки передач не найден." }, status: :not_found
    end

    def gearbox_type_params
      params.require(:gearbox_type).permit(:name, :abbreviation)
    end
end
