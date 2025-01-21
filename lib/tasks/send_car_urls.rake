require 'httparty'

namespace :plex_api do
  desc "Send all car URLs to Plex API"
  task send_cars_urls: :environment do
    # Получаем все автомобили
    cars = Car.all

    # Формируем массив items для отправки
    items = cars.map do |car|
      {
        id: car.id,
        siteId: 627,
        externalId: car.unique_id.to_i,
        url: car.url,
        isActive: car.online_view_available
      }
    end

    # Формируем тело запроса
    body = { items: items }

    # Отправляем запрос на Plex API
    response = HTTParty.post('https://plex-crm.ru/api/v3/offers/urls', 
      headers: {
        'Authorization' => "Bearer #{ENV['PLEX_CRM_TOKEN']}",
        'Content-Type' => 'application/json'
      },
      body: body.to_json
    )

    # Обрабатываем ответ
    if response.success?
      puts "Successfully sent URLs to Plex API."
    else
      puts "Failed to send URLs. Response: #{response.body}"
    end
  end
end
