class AboutCompaniesController < ApplicationController
  before_action :set_about_company, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @about_companies = AboutCompany.all
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @about_companies
    end
  end

  def show
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @about_company
    end
  end

  def create
    @about_company = AboutCompany.new(about_company_params)

    if @about_company.save
      render json: @about_company, status: :created
    else
      render json: @about_company.errors, status: :unprocessable_entity
    end
  end

  def update
    if @about_company.update(about_company_params)
      render json: @about_company, status: :ok
    else
      render json: @about_company.errors, status: :unprocessable_entity
    end
  end

  def update_multiple
    service = UpdateAboutCompaniesService.new(params[:about_companies])
    service.call
    render json: { message: 'Записи обновлены успешно.' }, status: :ok
  end

  def destroy
    if @about_company.destroy
      head :ok
    else
      render json: @about_company.errors, status: :internal_server_error
    end
  end

  private
    def set_about_company
      @about_company = AboutCompany.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Компания не найдена." }, status: :not_found
    end

    def about_company_params
      params.require(:about_company).permit(:description)
    end
end
