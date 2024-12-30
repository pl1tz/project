require 'open-uri'
require 'httparty'
require 'parallel'

namespace :import_api do
  task create_cars: :environment do
    url = 'https://plex-crm.ru/api/v3/offers/website/628'
    token = 'ezo4ysJQm1r1ZiFsFxBtp7zOV5rYAgYY9o3RWkz325009358'
    
    total_successful_imports = 0
    total_failed_imports = 0
    failed_cars = []
    current_page = 1
    
    start_time = Time.now
    
    loop do
      response = HTTParty.get(url, {
        headers: {
          'Authorization' => "Bearer #{token}",
          'Accept' => 'application/json'
        },
        query: {
          page: current_page,
          per_page: 50
        }
      })

      break unless response.success?

      data = response.parsed_response
      cars_data = data['items']
      pagination = data['pagination']
      
      break if cars_data.empty?

      total_pages = pagination['totalPages']
      total_items = pagination['totalItems']

      if current_page == 1
        puts "\nStarting import of #{total_items} cars (#{total_pages} pages)..."
      end
      
      puts "\nProcessing page #{current_page}/#{total_pages}..."
      
      page_successful = 0
      page_failed = 0

      ActiveRecord::Base.transaction do
        cars_data.each do |car_data|
          car = create_car_from_api_data(car_data)
          
          if car
            create_history_for_api_car(car, car_data)
            save_images_for_api_car(car, car_data)
            save_extras_for_api_car(car, car_data)
            page_successful += 1
            total_successful_imports += 1
            puts "Car created from API: #{car.brand.name} #{car.model.name} (#{total_successful_imports}/#{total_items})"
          else
            page_failed += 1
            total_failed_imports += 1
            failed_cars << "#{car_data.dig('mark', 'name')} #{car_data.dig('model', 'name')} (ID: #{car_data['uniqueId']})"
          end
        end
      end

      puts "\nPage #{current_page} results:"
      puts "Successfully imported: #{page_successful}"
      puts "Failed to import: #{page_failed}"

      break if current_page >= total_pages
      current_page += 1
    end

    # Итоговая статистика
    puts "\n========== Final Import Summary =========="
    puts "Total cars processed: #{total_successful_imports + total_failed_imports}"
    puts "Successfully imported: #{total_successful_imports}"
    puts "Failed to import: #{total_failed_imports}"
    
    if total_failed_imports > 0
      puts "\nFailed cars:"
      failed_cars.each { |car| puts "- #{car}" }
    end
    
    puts "======================================"

    end_time = Time.now
    duration = (end_time - start_time) / 60
    puts "Total import time: #{duration.round(2)} minutes"
  end

  private

  def create_car_from_api_data(car_data)
    brand = Brand.find_or_create_by(name: car_data.dig('mark', 'name'))
    model = Model.find_or_create_by(
      name: car_data.dig('model', 'name'),
      brand: brand
    )
    
    generation = Generation.find_or_create_by(
      name: car_data.dig('generation', 'title'),
      model: model
    ) if car_data['generation']

    car = Car.new(
      model: model,
      brand: brand,
      generation: generation,
      unique_id: car_data['uniqueId'],
      year: car_data['year'],
      price: car_data['price'],
      description: car_data['description'],
      color: Color.find_or_create_by(name: car_data.dig('color', 'name')),
      body_type: BodyType.find_or_create_by(name: car_data.dig('bodyType', 'name')),
      engine_name_type: EngineNameType.find_or_create_by(name: car_data.dig('engineType', 'name')),
      engine_power_type: EnginePowerType.find_or_create_by(power: car_data['enginePower']),
      engine_capacity_type: EngineCapacityType.find_or_create_by(capacity: car_data['engineVolume']),
      gearbox_type: find_or_create_gearbox_type_from_api(car_data.dig('gearbox', 'name')),
      drive_type: DriveType.find_or_create_by(name: car_data.dig('driveType', 'name') || "Полный"),
      online_view_available: true,
      complectation_name: car_data['complectation']
    )

    if car.save
      car
    else
      puts "\nFailed to create car: #{car_data.dig('mark', 'name')} #{car_data.dig('model', 'name')}"
      puts "Errors: #{car.errors.full_messages.join(", ")}"
      nil
    end
  end

  def create_history_for_api_car(car, car_data)
    HistoryCar.create!(
      car: car,
      vin: car_data['vin'],
      last_mileage: car_data['run'],
      previous_owners: car_data.dig('owners', 'name')&.to_i || 1,
      registration_number: "Отсутствует",
      registration_restrictions: "Не найдены ограничения на регистрацию",
      registration_restrictions_info: "Запрет регистрационных действий на машину накладывается, если у автовладельца есть неоплаченные штрафы и налоги, либо если имущество стало предметом спора.",
      wanted_status: "Нет сведений о розыске",
      wanted_status_info: "Покупка разыскиваемого автомобиля грозит тем, что его отберут в ГИБДД при регистрации, и пока будет идти следствие, а это может затянуться на долгий срок, автомобиль будет стоять на штрафплощадке.",
      pledge_status: "Залог не найден",
      pledge_status_info: "Мы проверили базы данных Федеральной нотариальной палаты (ФНП) и Национального бюро кредитных историй (НБКИ).",
      accidents_found: "ДТП не найдены",
      accidents_found_info: "В отчёт не попадут аварии, которые произошли раньше 2015 года или не оформлялись в ГИБДД.",
      repair_estimates_found: "Не найдены расчёты стоимости ремонта",
      repair_estimates_found_info: "Мы проверяем, во сколько эксперты страховых компаний оценили восстановление автомобиля после ДТП.",
      taxi_usage: "Не найдено разрешение на работу в такси",
      taxi_usage_info: "Данные представлены из региональных баз по регистрации автомобиля в качестве такси.",
      carsharing_usage: "Не найдены сведения об использовании в каршеринге",
      carsharing_usage_info: "На каршеринговых авто ездят практически круглосуточно.",
      diagnostics_found: "Не найдены сведения о диагностике",
      diagnostics_found_info: "В блоке представлены данные по оценке состояния автомобиля по результатам офлайн диагностики.",
      technical_inspection_found: "Не найдены сведения о техосмотрах",
      technical_inspection_found_info: "В данном блоке отображаются данные о прохождении техосмотра на основании данных диагностических карт ТС.",
      imported: "Нет сведений о ввозе из-за границы",
      imported_info: "Данные из таможенной декларации.",
      insurance_found: "Нет полиса ОСАГО",
      recall_campaigns_found: "Не найдены сведения об отзывных кампаниях",
      recall_campaigns_found_info: "Для данного автомобиля не проводилось или нет действующих отзывных кампаний."
    )
  end

  def save_images_for_api_car(car, car_data)
    return unless car_data['images'].is_a?(Array)
    
    car_data['images'].each do |image_data|
      Image.create(
        car: car,
        url: image_data['original']
      )
    end
    puts "Images saved for car: #{car.id}"
  end

  def save_extras_for_api_car(car, car_data)
    return unless car_data['equipment'].is_a?(Hash)
    
    car_data['equipment'].each do |category_name, extras|
      next unless extras.is_a?(Array)
      
      category = Category.find_or_create_by(name: category_name)
      extras.each do |extra|
        extra_name = ExtraName.find_or_create_by(name: extra)
        Extra.create(car: car, category: category, extra_name: extra_name)
      end
    end
    puts "Extras saved for car: #{car.id}"
  end

  def find_or_create_gearbox_type_from_api(gearbox_name)
    return nil unless gearbox_name
    
    abbreviations = {
      'Автоматическая' => 'АКПП',
      'Механическая' => 'МКПП',
      'Вариатор' => 'CVT',
      'Робот' => 'РКПП'
    }
    
    GearboxType.find_or_create_by(name: gearbox_name) do |gt|
      gt.abbreviation = abbreviations[gearbox_name]
    end
  end
end