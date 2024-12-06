class BannersController < ApplicationController
  before_action :set_banner, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /banners or /banners.json
  def index
    @banners = Banner.active
    render json: @banners
  end

  # GET /banners/1 or /banners/1.json
  def show
    render json: @banner
  end

  # POST /banners or /banners.json
  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      render json: @banner, status: :ok
    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /banners/1 or /banners/1.json
  def update
    # Сначала обновляем текущий баннер
    if @banner.update(banner_params)
      render json: @banner, status: :ok
    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

  # DELETE /banners/1 or /banners/1.json
  def destroy
    if @banner.destroy
      head :ok

    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

  def banner_all
  @banners =  BannerService.fetch_all_banners
  render json: @banners
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner
      @banner = Banner.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Баннер не найден' }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def banner_params
      params.require(:banner).permit(:image, :status, :main_text, :second_text)
    end
end
