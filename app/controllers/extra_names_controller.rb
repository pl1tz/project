class ExtraNamesController < ApplicationController
  before_action :set_extra_name, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @extra_names = ExtraName.all
    render json: @extra_names
  end

  def show
    render json: @extra_name
  end

  def create
    @extra_name = ExtraName.new(extra_name_params)

    if @extra_name.save
      render json: @extra_name, status: :created
    else
      render json: @extra_name.errors, status: :unprocessable_entity
    end
  end 

  def update
    if @extra_name.update(extra_name_params)
      render json: @extra_name, status: :ok
    else
      render json: @extra_name.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if Extra.exists?(extra_name_id: @extra_name.id)
      render json: { error: "Название дополнительного оборудования не может быть удалено, так как используется." }, status: :unprocessable_entity
    else
      if @extra_name.destroy
        head :ok    
      else
        render json: @extra_name.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_extra_name
      @extra_name = ExtraName.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Название дополнительного оборудования не найдено." }, status: :not_found
    end

    def extra_name_params
      params.require(:extra_name).permit(:name)
    end
end
