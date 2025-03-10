require 'nokogiri'
require 'dotenv/load'

namespace :generate do
  desc "Generate Yandex feed"
  task yandex_feed: :environment do
    cars = Car.includes(:brand, :model, :generation, :color, :body_type).all
    brands = Brand.pluck(:name)

    base_url = ENV['REACT_APP_BASE_URL']

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.yml_catalog(date: Time.now.iso8601) do
        xml.shop do
          xml.name "YOUAUTOPLUS"
          xml.company "YOUAUTOPLUS"
          xml.url base_url
          xml.currencies do
            xml.currency(id: "RUR", rate: "1")
          end
          xml.categories do
            xml.category(id: "1") { xml.text "Авто с пробегом" }

            brands.each_with_index do |brand, index|
              xml.category(id: index + 1, parentId: "50003") { xml.text brand }
            end
          end
          xml.sets do
            brands.each_with_index do |brand, index|
              xml.set(id: "s#{index + 1}") do
                xml.name "Автомобили #{brand} с пробегом в Москве"
                xml.url "#{base_url}/cars?brand_name=#{brand}&price_asc=true"
              end
            end
          end
          xml.offers do
            cars.each do |car|
              xml.offer(id: car.unique_id, available: car.online_view_available) do
                xml.name "#{car.brand.name} #{car.model.name}, #{car.year} года"
                xml.set_ids "s#{car.brand_id}"
                xml.url "#{base_url}/car/#{car.brand.name}/#{car.unique_id}"
                xml.picture car.images.first.url if car.images.any?
                xml.description car.description
                xml.price(from: "true") { xml.text car.price }
                xml.currencyId "RUR"
              end
            end
          end
        end
      end
    end

    File.write(Rails.root.join('public', 'yandex_feed.xml'), builder.to_xml)
    puts "Yandex feed generated successfully."
  end
end 