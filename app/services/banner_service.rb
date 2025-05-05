# app/services/banner_service.rb
class BannerService
  include Rails.application.routes.url_helpers

  def initialize; end

  def fetch_all_banners
    banners = Banner.all.sort_by(&:id)
    banners.map do |banner|
      {
        id: banner.id,
        images: banner.image,
        image2: banner.image2,
        status: banner.status,
        text: {
          main_text: banner.main_text,
          second_text: banner.second_text
        },
        image_urls: banner.images.map { |img| url_for(img) },
        image_info: banner.images.map { |img| detail_image_info(img) }
      }
    end
  end

  private
  def detail_image_info(image)
    blob = image.blob

    file_content = blob.download
    base64_content = Base64.strict_encode64(file_content)
    thumb_url = "data:#{blob.content_type};base64,#{base64_content}"

    {
      thumb_url: thumb_url 
    }
  end
end




# # Считываем содержимое файла


# # Кодируем содержимое в base64
# base64_content = Base64.strict_encode64(file_content)

# # Собираем thumbUrl
# thumb_url = "data:#{blob.content_type};base64,#{base64_content}"

# # Собираем весь объект
# result = {
#   uid: "rc-upload-#{blob.id}-#{SecureRandom.hex(4)}",
#   name: blob.filename.to_s,
#   status: "done",
#   thumbUrl: thumb_url,
#   type: blob.content_type,
#   size: blob.byte_size,
#   percent: 100,
#   originFileObj: {} # если нужно что-то изначальное, можно дополнить
# }

# puts result

