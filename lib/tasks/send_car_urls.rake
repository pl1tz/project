require 'httparty'

namespace :plex_api do
  desc "Send all car URLs to Plex API"
  task send_cars_urls: :environment do
    # Получаем все автомобили
    cars = Car.all

    items = cars.map do |car|
      next unless car.url.present?

      {
        id: car.unique_id.to_i,
        siteId: ENV['SITE_ID'].to_i,
        externalId: car.id,
        url: car.url,
        isActive: car.online_view_available
      }
    end.compact

    if items.empty?
      puts "No valid URLs to send."
      next
    end

    # Разбиваем массив на части по 1000 элементов
    items.each_slice(1000) do |items_batch|
      body = { items: items_batch }

      response = HTTParty.post('https://plex-crm.ru/api/v3/offers/urls', 
        headers: {
          'Authorization' => "Bearer #{ENV['PLEX_CRM_TOKEN']}",
          'Content-Type' => 'application/json'
        },
        body: body.to_json
      )

      if response.success?
        puts "Successfully sent #{items_batch.size} URLs to Plex API."
      else
        puts "Failed to send URLs. Response: #{response.body}"
      end
    end
  end
end
