class FavoritesController < ApplicationController
  def index
    @favorites = get_favorites_from_storage
    response.headers['Cache-Control'] = 'public, max-age=3600'
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @favorites
    end
  end

  private

  def get_favorites_from_storage
    []
  end
end


