class BannersController < ApplicationController
  before_action :set_banner, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /banners or /banners.json
  def index
    @banners = Banner.active
    render json: @banners.map { |banner| banner_with_images(banner) }
  end

  # GET /banners/1 or /banners/1.json
  def show
    render json: banner_with_images(@banner)
  end

  # POST /banners or /banners.json
  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      render json: banner_with_images(@banner), status: :ok
    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /banners/1 or /banners/1.json
  def update
    delete_images = JSON.parse(params[:banner][:deleted_images] || '[]')

    delete_images.each do |url|
      image_to_delete = find_image_by_url(@banner.images, url)
      image_to_delete&.purge
    end

    # Сначала обновляем текущий баннер
    if @banner.update(banner_params.except(:images))
      # Добавляем новые изображения, если они есть
      if params[:banner][:images].present?
        params[:banner][:images].each do |image|
          @banner.images.attach(image)
        end
      end
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
    # TODO: add presenters
    @banners = BannerService.new.fetch_all_banners

    render json: @banners
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_banner
    @banner = Banner.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Баннер не найден' }, status: :not_found
  end

  def banner_with_images(banner)
    banner.as_json.merge(image_urls: banner.images.map { |img| url_for(img) })
  end

  # Only allow a list of trusted parameters through.
  def banner_params
    params.require(:banner).permit(:image, :image2, :status, :main_text, :second_text, images: [])
  end

  def find_image_by_url(images, url)
    filename = url.split('/').last
    images.find { |img| url_for(img).split('/').last == filename }
  end
end
