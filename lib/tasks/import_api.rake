require 'open-uri'
require 'httparty'
require 'parallel'

# usecar.ru 267
# usecarmax.ru 628
# youautoplus.ru 627
# youautoplus.ru 1543
namespace :import_api do
  task delete_diff_cars: :environment do
    task = Task.create(name: 'delete diff cars', status: 'running')

    url = 'https://app.plex-crm.ru/api/v3/offers/website/' + ENV['SITE_ID'].to_s
    token = ENV['PLEX_CRM_TOKEN']
    
    puts "Fetching cars from API..."
    api_ids = []
    current_page = 1
    
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

      unless response.success?
        puts "[#{Time.now}]\n========== REQUEST FAILED =========="
        puts "[#{Time.now}] Status Code: #{response.code}"
        puts "[#{Time.now}] Response Body: #{response.body}"
        puts "[#{Time.now}] Error: #{response.message}" if response.message
        break
      end
      
      data = response.parsed_response
      cars_data = data['items']
      break if cars_data.empty?
      
      # Собираем unique_ids из API
      api_ids += cars_data.map { |car| car['id'] }
      current_page += 1
    end

    if !api_ids.empty?
      # Удаляем машины, которых нет в API
      cars_to_delete = Car.where.not(unique_id: api_ids)
      count = cars_to_delete.count
      
      if count > 0
        cars_to_delete.destroy_all
        puts "[#{Time.now}] Removed #{count} cars that are not present in the API."
      else
        puts "[#{Time.now}] No cars to remove."
      end
    else
      puts "[#{Time.now}] ================API IDS IS EMPTY==================="
      puts "[#{Time.now}] ===========SOMETHING WRONG WITH API================"
      puts "[#{Time.now}] No cars to remove."
    end

    # Обновляем задачу после выполнения
    task.update(status: 'completed')
  end

  task create_cars: :environment do
    task = Task.create(name: 'create cars', status: 'running')

    url = 'https://app.plex-crm.ru/api/v3/offers/website/' + ENV['SITE_ID'].to_s
    token = ENV['PLEX_CRM_TOKEN']
    
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

      unless response.success?
        puts "[#{Time.now}]\n========== REQUEST FAILED =========="
        puts "[#{Time.now}] Status Code: #{response.code}"
        puts "[#{Time.now}] Response Body: #{response.body}"
        puts "[#{Time.now}] Error: #{response.message}" if response.message
        break
      end

      data = response.parsed_response
      cars_data = data['items']
      pagination = data['pagination']
      
      break if cars_data.empty?

      total_pages = pagination['totalPages']
      total_items = pagination['totalItems']

      if current_page == 1
        puts "[#{Time.now}]\nStarting import of #{total_items} cars (#{total_pages} pages)..."
      end
      
      puts "[#{Time.now}]\nProcessing page #{current_page}/#{total_pages}..."
      
      page_successful = 0
      page_failed = 0

      ActiveRecord::Base.transaction do
        cars_data.each do |car_data|
          # Ищем существующую машину
          existing_car = Car.find_by(unique_id: car_data['id'])
          
          if existing_car
            puts "[#{Time.now}] Car already exists, skipping: #{existing_car.brand.name} #{existing_car.model.name}"
          else
            # Создаем новую машину
            car = create_car_from_api_data(car_data)
            if car
              page_successful += 1
              total_successful_imports += 1
              puts "[#{Time.now}] New car created: #{car.brand.name} #{car.model.name}"
            else
              page_failed += 1
              total_failed_imports += 1
              failed_cars << "#{car_data.dig('mark', 'name')} #{car_data.dig('model', 'name')} (ID: #{car_data['id']})"
            end
          end
        end
      end

      puts "[#{Time.now}] Successfully imported: #{page_successful}"
      puts "[#{Time.now}] Failed to import: #{page_failed}"

      break if current_page >= total_pages
      current_page += 1
    end

    # Итоговая статистика
    puts "[#{Time.now}] =========== Final Import Summary =========="
    puts "[#{Time.now}] Total cars processed: #{total_successful_imports + total_failed_imports}"
    puts "[#{Time.now}] Successfully imported: #{total_successful_imports}"
    puts "[#{Time.now}] Failed to import: #{total_failed_imports}"
    
    if total_failed_imports > 0
      puts "\nFailed cars:"
      failed_cars.each { |car| puts "- #{car}" }
    end
    
    puts "======================================"

    end_time = Time.now
    duration = (end_time - start_time) / 60
    puts "[#{Time.now}] Total import time: #{duration.round(2)} minutes"

    # Обновляем задачу после выполнения
    task.update(status: 'completed')
  end

  task update_cars: :environment do
    task = Task.create(name: 'update cars', status: 'running')

    url = 'https://app.plex-crm.ru/api/v3/offers/website/' + ENV['SITE_ID'].to_s
    token = ENV['PLEX_CRM_TOKEN']
    
    total_successful_updates = 0
    total_failed_updates = 0
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

      unless response.success?
        puts "[#{Time.now}]\n========== REQUEST FAILED =========="
        puts "[#{Time.now}] Status Code: #{response.code}"
        puts "[#{Time.now}] Response Body: #{response.body}"
        puts "[#{Time.now}] Error: #{response.message}" if response.message
        break
      end

      data = response.parsed_response
      cars_data = data['items']
      pagination = data['pagination']
      
      break if cars_data.empty?

      total_pages = pagination['totalPages']

      puts "[#{Time.now}]\nProcessing page #{current_page}/#{total_pages}..."
      
      page_successful = 0
      page_failed = 0

      ActiveRecord::Base.transaction do
        cars_data.each do |car_data|
          # Ищем существующую машину
          existing_car = Car.find_by(unique_id: car_data['id'])
          
          if existing_car
            # Обновляем существующую машину
            if update_existing_car(existing_car, car_data)
              update_history_for_api_car(existing_car, car_data)
              update_images_for_api_car(existing_car, car_data)
              update_extras_for_api_car(existing_car, car_data)
              page_successful += 1
              total_successful_updates += 1
              puts "[#{Time.now}] Car updated: #{existing_car.brand.name} #{existing_car.model.name}"
            else
              page_failed += 1
              total_failed_updates += 1
              failed_cars << "#{car_data.dig('mark', 'name')} #{car_data.dig('model', 'name')} (ID: #{car_data['id']})"
            end
          else
            puts "[#{Time.now}] Car not found for update, skipping: #{car_data.dig('mark', 'name')} #{car_data.dig('model', 'name')}"
          end
        end
      end

      puts "[#{Time.now}]\nPage #{current_page} results:"
      puts "[#{Time.now}] Successfully updated: #{page_successful}"
      puts "[#{Time.now}] Failed to update: #{page_failed}"

      break if current_page >= total_pages
      current_page += 1
    end

    # Итоговая статистика
    puts "[#{Time.now}] =========== Final Update Summary =========="
    puts "[#{Time.now}] Total cars processed: #{total_successful_updates + total_failed_updates}"
    puts "[#{Time.now}] Successfully updated: #{total_successful_updates}"
    puts "[#{Time.now}] Failed to update: #{total_failed_updates}"
    
    if total_failed_updates > 0
      puts "\nFailed cars:"
      failed_cars.each { |car| puts "- #{car}" }
    end
    
    puts "======================================"

    end_time = Time.now
    duration = (end_time - start_time) / 60
    puts "[#{Time.now}] Total update time: #{duration.round(2)} minutes"

    task.update(status: 'completed')
  end

  private

  def create_car_from_api_data(car_data)
    brand = Brand.find_or_create_by(name: car_data.dig('mark', 'title'))
    model = Model.find_or_create_by(
      name: car_data.dig('model', 'title'),
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
      unique_id: car_data['id'],
      year: car_data['year'],
      price: car_data['price'],
      description: car_data['modification'],
      color: Color.find_or_create_by(name: car_data.dig('color', 'title')),
      body_type: BodyType.find_or_create_by(name: car_data.dig('bodyType', 'title')),
      engine_name_type: EngineNameType.find_or_create_by(name: car_data.dig('engineType', 'title')),
      engine_power_type: EnginePowerType.find_or_create_by(power: car_data['enginePower']),
      engine_capacity_type: EngineCapacityType.find_or_create_by(capacity: car_data['engineVolume']),
      gearbox_type: find_or_create_gearbox_type_from_api(car_data.dig('gearbox', 'title')),
      drive_type: DriveType.find_or_create_by(name: car_data.dig('driveType', 'title') || "Полный"),
      online_view_available: true,
      complectation_name: car_data['complectation']
    )
  
    if car.save
      car.update(url: "#{ENV['REACT_APP_BASE_URL']}/car/#{brand.name}/#{car.unique_id}")

      # Добавляем историю автомобиля
      create_history_for_api_car(car, car_data)
  
      # Сохраняем изображения
      save_images_for_api_car(car, car_data)
  
      # Сохраняем дополнительные опции
      save_extras_for_api_car(car, car_data)
  
      puts "[#{Time.now}] New car created with full details: #{car.brand.name} #{car.model.name}"
      car
    else
      puts "[#{Time.now}]\nFailed to create car: #{car_data.dig('mark', 'title')} #{car_data.dig('model', 'title')}"
      puts "[#{Time.now}] Errors: #{car.errors.full_messages.join(', ')}"
      nil
    end
  end

  def create_history_for_api_car(car, car_data)
    HistoryCar.create!(
      car: car,
      vin: car_data['vin'],
      last_mileage: car_data['run'],
      previous_owners: car_data.dig('owners', 'title')&.to_i || 1,
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
    puts "[#{Time.now}] Images saved for car: #{car.id}"
  end

  def save_extras_for_api_car(car, car_data)
    return unless car_data['equipment'].is_a?(Hash)

    car_data['equipment'].each do |category_name, extra_data|
      next unless extra_data.is_a?(Hash) # Проверяем, что это хэш

      # Извлекаем значение из хэша
      extra_value = extra_data['value']
      next if extra_value.blank? # Пропускаем пустые значения

      # Определяем категорию на основе названия extra
      category_title = determine_category(extra_value)

      # Находим или создаем категорию
      category = Category.find_or_create_by(name: category_title)

      # Создаем или находим имя extra
      extra_name = ExtraName.find_or_create_by(name: extra_value)
      Extra.create(car: car, category: category, extra_name: extra_name)
    end
    puts "[#{Time.now}] Extras saved for car: #{car.id}"
  end

  def determine_category(extra)
    case extra
    when /фары|датчик/
      'Обзор'
    when /диски|рейлинги/
      'Элементы экстерьера'
    when /иммобилайзер|замок|сигнализация/
      'Защита от угона'
    when /audi|usb|bluetooth|навигационная система|розетка/
      'Мультимедиа'
    when /салон|обогрев|подогрев|подголовник|регулировка|подлокотник/
      'Салон'
    when /камера|климат|компьютер|мультифункциональное|складывание|доступ|парктроник|круиз|усилитель|привод|стеклоподъемники|прикуриватель/
      'Комфорт'
    when /система|подушка/
      'Безопасность'
    else
      'Прочее'
    end
  end

  def find_or_create_gearbox_type_from_api(gearbox_name)
    return nil unless gearbox_name

    abbreviations = {
      'Автомат' => 'АКПП',
      'Механика' => 'МКПП',
      'Вариатор' => 'CVT',
      'Робот' => 'РКПП'
    }

    GearboxType.find_or_create_by(name: gearbox_name) do |gt|
      gt.abbreviation = abbreviations[gearbox_name]
    end
  end

  def update_existing_car(existing_car, car_data)
    existing_car.update(  
      year: car_data['year'],
      price: car_data['price'],
      description: car_data['modification'],
      color: Color.find_or_create_by(name: car_data.dig('color', 'title')),
      body_type: BodyType.find_or_create_by(name: car_data.dig('bodyType', 'title')),
      engine_name_type: EngineNameType.find_or_create_by(name: car_data.dig('engineType', 'title')),
      engine_power_type: EnginePowerType.find_or_create_by(power: car_data['enginePower']),
      engine_capacity_type: EngineCapacityType.find_or_create_by(capacity: car_data['engineVolume']),
      gearbox_type: find_or_create_gearbox_type_from_api(car_data.dig('gearbox', 'title') || 'Неизвестно'),
      drive_type: DriveType.find_or_create_by(name: car_data.dig('driveType', 'title') || "Полный"),
      complectation_name: car_data['complectation'],
      url: "#{ENV['REACT_APP_BASE_URL']}/car/#{existing_car.brand.name}/#{existing_car.unique_id}"
    )
  end

  def update_history_for_api_car(car, car_data)
    # Удаляем старую историю
    car.history_cars.destroy_all
    # Создаем новую историю
    create_history_for_api_car(car, car_data)
  end

  def update_images_for_api_car(car, car_data)
    # Удаляем старые изображения
    car.images.destroy_all
    # Создаем новые изображения
    save_images_for_api_car(car, car_data)
  end

  def update_extras_for_api_car(car, car_data)
    # Удаляем старые extras
    car.extras.destroy_all
    # Создаем новые extras
    save_extras_for_api_car(car, car_data)
  end
end
