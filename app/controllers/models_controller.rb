class ModelsController < ApplicationController
  before_action :set_model, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token
  
  def index
    @models = Model.all
    render json: @models
  end

  def show
    render json: @model
  end

  def create
    @model = Model.new(model_params)
    if @model.save
      render json: @model, status: :created
    else
      render json: @model.errors, status: :unprocessable_entity
    end   
  end

  def update
    if @model.update(model_params)
      render json: @model, status: :ok
    else
      render json: @model.errors, status: :unprocessable_entity
    end           
  end

  def destroy
    if Car.exists?(model_id: @model.id) || CallRequest.exists?(model_id: @model.id)
      render json: { error: "Невозможно удалить модель, так как она используется в таблице автомобилей или заявок на звонок." }, status: :unprocessable_entity
    else
      if @model.destroy
        head :ok
    else
        render json: @model.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_model
      @model = Model.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Модель не найдена." }, status: :not_found
    end

    def model_params
      params.require(:model).permit(:name, :brand_id)
    end
end
