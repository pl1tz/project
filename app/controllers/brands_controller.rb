class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    @brands = Brand.all
    render json: @brands
  end

  def show
    render json: @brand
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      render json: @brand, status: :created
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  def update
    if @brand.update(brand_params)
      render json: @brand, status: :ok
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if Car.exists?(brand_id: @brand.id) || Model.exists?(brand_id: @brand.id)
        render json: { error: "Невозможно удалить бренд, так как он используется в таблицах автомобилей или моделей." }, status: :unprocessable_entity
    else
        if @brand.destroy
            head :ok
        else
            render json: @brand.errors, status: :unprocessable_entity
        end
    end
  end

  private

  def set_brand
    @brand = Brand.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Бренд не найден." }, status: :not_found
  end

  def brand_params
    params.require(:brand).permit(:name)
  end
end
