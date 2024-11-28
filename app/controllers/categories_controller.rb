class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @categories = Category.all  
    render json: @categories
  end

  def show
    render json: @category
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end   
  end

  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end 
  end

  def destroy
    if Extra.where(category_id: @category.id).exists?
      render json: { error: "Категория не может быть удалена, так как используется." }, status: :unprocessable_entity
    else
      if @category.destroy
        head :ok    
      else
        render json: @category.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_category
      @category = Category.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Категория не найдена." }, status: :not_found
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
