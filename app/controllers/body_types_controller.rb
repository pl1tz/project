class BodyTypesController < ApplicationController
  before_action :set_body_type, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @body_types = BodyType.all
    render json: @body_types
  end

  def show
    render json: @body_type
  end

  def create
    @body_type = BodyType.new(body_type_params)
    if @body_type.save
      render json: @body_type, status: :created
    else
      render json: @body_type.errors, status: :unprocessable_entity
    end     
  end

  def update
    if @body_type.update(body_type_params)
      render json: @body_type, status: :ok
    else
      render json: @body_type.errors, status: :unprocessable_entity
    end
  end     

  def destroy
    if Car.exists?(body_type_id: @body_type.id)
      render json: { error: "Невозможно удалить тип кузова, так как он используется в таблице автомобилей." }, status: :unprocessable_entity
    else
      if @body_type.destroy
        head :ok
      else
        render json: @body_type.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_body_type
      @body_type = BodyType.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Тип кузова не найден." }, status: :not_found
    end

    def body_type_params
      params.require(:body_type).permit(:name)
    end
end
