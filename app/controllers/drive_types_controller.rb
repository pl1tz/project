class DriveTypesController < ApplicationController
  before_action :set_drive_type, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @drive_types = DriveType.all 
    render json: @drive_types
  end

  def show
    render json: @drive_type
  end

  def create
    @drive_type = DriveType.new(drive_type_params)

    if @drive_type.save
      render json: @drive_type, status: :created
    else
      render json: @drive_type.errors, status: :unprocessable_entity
    end
  end     

  def update
    if @drive_type.update(drive_type_params)
      render json: @drive_type, status: :ok
    else
      render json: @drive_type.errors, status: :unprocessable_entity
    end
  end   

  def destroy
    if Car.exists?(drive_type_id: @drive_type.id)
      render json: { error: "Невозможно удалить тип привода, так как он используется в таблице автомобилей." }, status: :unprocessable_entity
    else
      if @drive_type.destroy
        head :ok
      else
        render json: @drive_type.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_drive_type
      @drive_type = DriveType.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Тип привода не найден." }, status: :not_found
    end

    def drive_type_params
      params.require(:drive_type).permit(:name)
    end
end
