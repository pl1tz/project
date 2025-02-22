class FeedsController < ApplicationController
  def yandex_feed
    # Генерация XML-файла
    cars = Car.includes(:brand, :model, :generation, :color, :body_type).all
    brands = Brand.pluck(:name)

    base_url = ENV['REACT_APP_BASE_URL']

    # Извлечение части из base_url
    site_name = base_url.split('//').last.split('.').first.upcase

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.yml_catalog(date: Time.now.iso8601) do
        xml.shop do
          xml.name site_name
          xml.company site_name
          xml.url base_url
          xml.currencies do
            xml.currency(id: "RUR", rate: "1")
          end
          xml.categories do
            xml.category(id: "50003") { xml.text "Авто с пробегом" }
            brands.each_with_index do |brand, index|
              xml.category(id: index + 1, parentId: "50003") { xml.text brand }
            end
          end
          xml.sets do
            brands.each_with_index do |brand, index|
              xml.set(id: "s#{index + 1}") do
                xml.name "Автомобили #{brand} с пробегом в Москве"
                # Кодируем URL, заменяя пробелы на %20
                xml.url "#{base_url}/cars?brand_name=#{CGI.escape(brand)}"
              end
            end
          end
          xml.offers do
            cars.each do |car|
              xml.offer(id: car.unique_id, available: car.online_view_available) do
                xml.name "#{car.brand.name} #{car.model.name}, #{car.year} года"
                xml.categoryId car.brand_id
                xml.send(:"set-ids", "s#{car.brand_id}")
                # Кодируем URL, заменяя пробелы на %20
                xml.url "#{base_url}/car/#{CGI.escape(car.brand.name).gsub('+', '%20')}/#{car.unique_id}"
                xml.picture car.images.first.url if car.images.any?
                xml.description car.description
                xml.param(name: "Конверсия") { xml.text "4.01711" }
                xml.price(from: "true") { xml.text car.price }
                xml.currencyId "RUR"
              end
            end
          end
        end
      end
    end

    # Устанавливаем заголовок для XML
    respond_to do |format|
      format.xml { render xml: builder.to_xml }
    end
  end
end
