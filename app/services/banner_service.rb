# app/services/banner_service.rb
class BannerService
  def self.fetch_all_banners
    banners = Banner.all
    banners.map do |banner|
      {
        id: banner.id,
        images: banner.image,
        status: banner.status,
        text: {
        main_text: banner.main_text,
        second_text: banner.second_text
        }
      }
    end
  end
end
