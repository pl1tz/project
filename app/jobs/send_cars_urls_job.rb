# 

class SendCarsUrlsJob
  include Sidekiq::Job

  def perform
    cars = Car.all

    items = cars.map do |car|
      next unless car.url.present?

      # Убираем пробелы, заменяя их на %20
      corrected_url = car.url.gsub(' ', '%20')

      {
        id: car.unique_id.to_i,
        siteId: ENV['SITE_ID'].to_i,
        externalId: car.id,
        url: corrected_url,
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

      response = HTTParty.post('https://app.plex-crm.ru/api/v3/offers/urls', 
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

        # Логирование ID и некорректных URL
        invalid_urls = JSON.parse(response.body)['errors']
        invalid_urls.each do |key, errors|
          if key.start_with?('items.')
            index = key.match(/\d+/)[0].to_i
            car_data = items_batch[index]
            puts "Invalid URL: Car ID #{car_data[:externalId]}, URL #{car_data[:url]}"
          end
        end
      end
    end
  end
end
