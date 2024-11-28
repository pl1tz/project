# app/services/banner_service.rb
class BannerService
    def self.fetch_active_banners
      active_banners = Banner.where(status: true)
      
  
      # Формируем массивы для изображений, статусов и текстов
      images = active_banners.map { |banner| { url: banner.image } }  # Массив объектов изображений
      status = active_banners.map(&:status)                          # Массив статусов
      text = active_banners.map do |banner| 
        { 
          main_text: banner.main_text, 
          secondary_text: banner.second_text
        } 
      end  # Массив объектов текстов
      text_2 = active_banners.map do |banner| 
        {  
          main_2_text: banner.main_2_text, 
          secondary_2_text: banner.second_2_text 
        } 
      end
      # Возвращаем хэш с массивами
      {
        images: images,
        status: status,
        text: text,
        text_2: text_2
      }
    end
  end