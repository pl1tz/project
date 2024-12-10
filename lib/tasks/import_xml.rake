namespace :import do
  task create_cars: :environment do
    require 'nokogiri'
    require 'open-uri'

    #file_path = Rails.root.join('app', 'assets', 'xml', 'hpbz0dmc.xml')
    #xml_data = File.read(file_path)
    xml_data = URI.open('https://plex-crm.ru/xml/usecarmax/hpbz0dmc').read
    doc = Nokogiri::XML(xml_data)

    ActiveRecord::Base.transaction do

      doc.xpath('//car').each do |node|
        car = create_car_from_node(node)
        next unless car

        create_history_for_car(car, node)
        save_images_for_car(car, node)
        save_extras_for_car(car, node)
        puts "Car created: #{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}"
      end
    end
  end

  task drop_cars: :environment do
    ActiveRecord::Base.transaction do
      # Удаление автомобилей
      existing_cars = Car.includes(
                                  :history_cars,
                                  :images,
                                  :extras
                                  ).all

      if existing_cars.empty?
        puts "No existing cars found. Skipping deletion."
      else
        if OrdersCredit.exists?
          OrdersCredit.destroy_all
        end
        if OrdersBuyout.exists?
          OrdersBuyout.destroy_all
        end
        if OrdersExchange.exists?
          OrdersExchange.destroy_all
        end
        if OrdersInstallment.exists?
          OrdersInstallment.destroy_all
        end
        if OrdersCallRequest.exists?
          OrdersCallRequest.destroy_all
        end
        if Credit.exists?
          Credit.destroy_all
        end
        if Buyout.exists?
          Buyout.destroy_all
        end
        if Exchange.exists?
          Exchange.destroy_all
        end
        if Installment.exists?
          Installment.destroy_all
        end
        if CallRequest.exists?
          OrdersCallRequest.destroy_all
        end
        existing_cars.each do |car|
          car.history_cars.destroy_all
          car.images.destroy_all
          car.extras.destroy_all
          car.destroy
          puts "Car removed: #{car.id}"
        end
      end
    end
  end


  task update_cars: :environment do
    require 'nokogiri'
    require 'open-uri'

    xml_data = URI.open('https://plex-crm.ru/xml/usecarmax/hpbz0dmc').read
    doc = Nokogiri::XML(xml_data)

    ActiveRecord::Base.transaction do
      # Получаем все существующие автомобили из базы данных
      existing_cars = Car.includes(:history_cars, :images, :extras).all
      puts "existing_cars: #{existing_cars}"

      # Обновление или добавление автомобилей
      doc.xpath('//car').each_slice(100) do |car_nodes|  # Обработка по 100 узлов за раз
        car_nodes.each do |node|
          unique_id_xml = node.at_xpath('unique_id').text
          puts "unique_id xml: #{unique_id_xml}"

          # Поиск существующего автомобиля по unique_id
          car = Car.find_by(unique_id: unique_id_xml)

          if car
            # Если автомобиль существует, обновляем его
            update_car(car, node)
            # Обновляем историю автомобиля
            update_history_for_car(car, node)
            # Обновляем изображения
            update_images_for_car(car, node)
            # Обновляем комплектацию
            update_extras_for_car(car, node)
          else
            # Если автомобиль не существует, создаем новый
            car = create_car_from_node(node)
            next unless car
            create_history_for_car(car, node)
            save_images_for_car(car, node)
            save_extras_for_car(car, node)
            puts "Car created: #{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}"
          end
        end
      end
    end
  end

  task delete_diff_cars: :environment do
    require 'nokogiri'
    require 'open-uri'

    xml_data = URI.open('https://plex-crm.ru/xml/usecarmax/hpbz0dmc').read
    doc = Nokogiri::XML(xml_data)

    ActiveRecord::Base.transaction do
      # Получаем все существующие автомобили из базы данных
      existing_cars = Car.includes(:history_cars, :images, :extras).all
      puts "existing_cars: #{existing_cars}"

      # Получаем уникальные идентификаторы из XML
      xml_unique_ids = doc.xpath('//car/unique_id').map(&:text)

      # Удаление автомобилей, которые отсутствуют в XML
      existing_cars.each do |car|
        puts "car: #{car.id}"
        unless xml_unique_ids.include?(car.unique_id)
          puts "Car removed: #{car.id} (unique_id: #{car.unique_id})"
          car.history_cars.destroy_all
          car.images.destroy_all
          car.extras.destroy_all
          car.destroy
        end
      end
    end
  end

  def remove_related_orders(car)
    if car.credit
      puts "Removing credit for car: #{car.id}"
      car.credit.destroy
    end
    if car.orders_credit.any?
      puts "Removing credit orders for car: #{car.id}"
      car.orders_credit.destroy_all
    end

    if car.orders_buyout.any?
      puts "Removing buyout orders for car: #{car.id}"
      car.orders_buyout.destroy_all
    end

    if car.orders_exchange.any?
      puts "Removing exchange orders for car: #{car.id}"
      car.orders_exchange.destroy_all
    end

    if car.orders_installment.any?
      puts "Removing installment orders for car: #{car.id}"
      car.orders_installment.destroy_all
    end

    if car.orders_call_request.any?
      puts "Removing call request orders for car: #{car.id}"
      car.orders_call_request.destroy_all
    end

    if car.credit
      puts "Removing credit for car: #{car.id}"
      car.credit.destroy
    end

    if car.buyout
      puts "Removing buyout for car: #{car.id}"
      car.buyout.destroy
    end

    if car.exchange
      puts "Removing exchange for car: #{car.id}"
      car.exchange.destroy
    end

    if car.installment
      puts "Removing installment for car: #{car.id}"
      car.installment.destroy
    end
  end

  def update_car(car, node)
    # Обновляем атрибуты автомобиля
    car.assign_attributes(
      year: node.at_xpath('year').text.to_i,
      price: node.at_xpath('price').text.to_d,
      description: node.at_xpath('modification_id').text,
      color: Color.find_or_create_by(name: node.at_xpath('color').text),
      body_type: BodyType.find_or_create_by(name: node.at_xpath('body_type').text),
      engine_name_type: EngineNameType.find_or_create_by(name: node.at_xpath('engine_type').text),
      engine_power_type: EnginePowerType.find_or_create_by(power: node.at_xpath('engine_power').text.to_i),
      engine_capacity_type: find_or_create_engine_capacity_type(node),
      gearbox_type: find_or_create_gearbox_type(node),
      drive_type: DriveType.find_or_create_by(name: node.at_xpath('drive')&.text || "Полный"),
      online_view_available: true,
      complectation_name: node.at_xpath('complectation_name').text
    )

    if car.save
      puts "Car updated: #{car.id}"
    else
      puts "Failed to update car: #{car.id}"
      puts car.errors.full_messages.join(", ")
    end
  end

  def create_car_from_node(node)
    brand = Brand.find_or_create_by(name: node.at_xpath('mark_id').text)
    model = Model.find_or_create_by(name: node.at_xpath('model_name').text, brand: brand)
    generation = find_or_create_generation(node, model)
    body_type = BodyType.find_or_create_by(name: node.at_xpath('body_type').text)
    color = Color.find_or_create_by(name: node.at_xpath('color').text)
    engine_name_type = EngineNameType.find_or_create_by(name: node.at_xpath('engine_type').text)
    engine_power_type = EnginePowerType.find_or_create_by(power: node.at_xpath('engine_power').text.to_i)
    engine_capacity_type = find_or_create_engine_capacity_type(node)
    gearbox_type = find_or_create_gearbox_type(node)
    drive_type = DriveType.find_or_create_by(name: node.at_xpath('drive')&.text || "Полный")

    car = Car.new(
      model: model,
      brand: brand,
      generation: generation,
      unique_id: node.at_xpath('unique_id').text,
      year: node.at_xpath('year').text.to_i,
      price: node.at_xpath('price').text.to_d,
      description: node.at_xpath('modification_id').text,
      color: color,
      body_type: body_type,
      engine_name_type: engine_name_type,
      engine_power_type: engine_power_type,
      engine_capacity_type: engine_capacity_type,
      gearbox_type: gearbox_type,
      drive_type: drive_type,
      online_view_available: true,
      complectation_name: node.at_xpath('complectation_name').text
    )

    if car.save
      puts "Car created for: #{car.brand.name} #{car.model.name} #{car.generation.name}"
      car
    else
      puts "Failed to create car for VIN: #{node.at_xpath('vin').text}"
      puts car.errors.full_messages.join(", ")
      nil
    end
  end

  def find_or_create_generation(node, model)
    generation = Generation.find_or_initialize_by(name: node.at_xpath('generation_name').text, model: model)
    generation.save unless generation.persisted?
    generation
  end

  def find_or_create_engine_capacity_type(node)
    modification_text = node.at_xpath('modification_id').text
    engine_capacity_match = modification_text.match(/(\d+\.\d+)/)
    engine_capacity = engine_capacity_match[1] if engine_capacity_match

    EngineCapacityType.find_or_create_by(
      capacity: engine_capacity.to_f 
    )
  end

  def find_or_create_gearbox_type(node)
    gearbox_name = node.at_xpath('gearbox').text
    abbreviations = {
      'Автоматическая' => 'АКПП',
      'Механическая' => 'МКПП',
      'Автомат вариатор' => 'CVT',
      'Автомат робот' => 'РКПП'
    }
    abbreviation = abbreviations[gearbox_name]

    GearboxType.find_or_create_by(name: gearbox_name) do |gt|
      gt.abbreviation = abbreviation
    end.tap do |gearbox_type|
      gearbox_type.update(abbreviation: abbreviation) if gearbox_type.abbreviation.blank?
    end
  end

  def create_history_for_car(car, node)
    vin = node.at_xpath('vin').text
  
    owners_number_text = node.at_xpath('owners_number').text.downcase.split.first
    text_to_number = {
      "ноль" => 0, "один" => 1, "два" => 2, "три" => 3, "четыре" => 4,
      "пять" => 5, "шесть" => 6, "семь" => 7, "восемь" => 8, "девять" => 9, "десять" => 10
    }
    owners_number = text_to_number[owners_number_text] || owners_number_text.scan(/\d+/).first.to_i
  
    # Получаем текстовое значение элемента 'run'
    run_value = node.at_xpath('run')&.text

    # Проверяем, является ли значение числом, и устанавливаем params_last_mileage
    params_last_mileage = (run_value && run_value.match?(/^\d+$/)) ? run_value.to_i : 10
  
    history_car = HistoryCar.create(
      car: car,
      vin: vin.present? ? vin : nil,
      last_mileage: params_last_mileage,
      previous_owners: owners_number,
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
      repair_estimates_found_info: "Мы проверяем, во сколько эксперты страховых компаний оценили восстановление автомобиля после ДТП. Расчёт не означает, что машину ремонтировали.",
      taxi_usage: "Не найдено разрешение на работу в такси",
      taxi_usage_info: "Данные представлены из региональных баз по регистрации автомобиля в качестве такси.",
      carsharing_usage: "Не найдены сведения об использовании в каршеринге",
      carsharing_usage_info: "На каршеринговых авто ездят практически круглосуточно. Они много времени проводят в пробках  от этого двигатель и сцепление быстро изнашиваются. Салон тоже страдает от большого количества водителей и пассажиров.",
      diagnostics_found: "Не найдены сведения о диагностике",
      diagnostics_found_info: "В блоке представлены данные по оценке состояния автомобиля по результатам офлайн диагностики. В ходе диагностики специалисты проверяют состояние ЛКП, всех конструкций автомобиля, состояние салона, фактическую комплектацию и проводят небольшой тест-драйв.",
      technical_inspection_found: "Не найдены сведения о техосмотрах",
      technical_inspection_found_info: "В данном блоке отображаются данные о прохождении техосмотра на основании данных диагностических карт ТС. Срок прохождения технического осмотра для автомобилей категории «B»: — первые четыре года — не требуется; — возраст от 4 до 10 лет — каждые 2 года; — старше 10 лет — ежегодно.",
      imported: "Нет сведений о ввозе из-за границы",
      imported_info: "Данные из таможенной декларации, которую заполняет компания, осуществляющая ввоз транспортного средства на территорию РФ.",
      insurance_found: "Нет полиса ОСАГО",
      recall_campaigns_found: "Не найдены сведения об отзывных кампаниях",
      recall_campaigns_found_info: "Для данного автомобиля не проводилось или нет действующих отзывных кампаний. Отзыв автомобиля представляет собой устранение выявленного брака. Практически все автомобильные производители периодически отзывают свои продукты для устранения дефектов."
    )
  
    if history_car.save
      puts "History saved for car: #{car.id}"
    else
      puts "History not created for car VIN: #{vin}"
      puts "Errors: #{history_car.errors.full_messages.join(", ")}"
    end
  end

  def save_images_for_car(car, node)
    node.xpath('images/image').each do |image_node|
      Image.create(car: car, url: image_node.text)
    end
    puts "Images saved for car: #{car.id}"
  end

  def save_extras_for_car(car, node)
    extras_string = node.at_xpath('extras').text
    extras_array = extras_string.split(',').map(&:strip)

    extras_array.each do |extra|
      category_name = case extra
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

      category = Category.find_or_create_by(name: category_name)
      extra_name = ExtraName.find_or_create_by(name: extra)
      Extra.create(car: car, category: category, extra_name: extra_name)
    end
    puts "Extras saved for car: #{car.id}"
  end

  def update_history_for_car(car, node)
    vin = node.at_xpath('vin').text
    history_car = car.history_cars.find_or_initialize_by(vin: vin)
  
    owners_number_text = node.at_xpath('owners_number').text.downcase.split.first
    text_to_number = {
      "ноль" => 0, "один" => 1, "два" => 2, "три" => 3, "четыре" => 4,
      "пять" => 5, "шесть" => 6, "семь" => 7, "восемь" => 8, "девять" => 9, "десять" => 10
    }
    owners_number = text_to_number[owners_number_text] || owners_number_text.scan(/\d+/).first.to_i
  
    # Получаем текстовое значение элемента 'run'
    run_value = node.at_xpath('run')&.text

    # Проверяем, является ли значение числом, и устанавливаем params_last_mileage
    params_last_mileage = (run_value && run_value.match?(/^\d+$/)) ? run_value.to_i : 10
  
    # Обновляем атрибуты истории
    history_car.assign_attributes(
      last_mileage: params_last_mileage,
      previous_owners: owners_number,
      vin: node.at_xpath('vin').text.present? ? node.at_xpath('vin').text : nil
      # Добавьте другие атрибуты, которые нужно обновить
    )

    if history_car.save
      puts "History updated for car: #{car.id}"
    else
      puts "Failed to update history for car VIN: #{vin}"
      puts history_car.errors.full_messages.join(", ")
    end
  end

  def update_images_for_car(car, node)
    existing_image_urls = car.images.pluck(:url)
    node.xpath('images/image').each do |image_node|
      image_url = image_node.text

      unless existing_image_urls.include?(image_url)
        Image.create(car: car, url: image_url)
        puts "Image added for car: #{car.id} (URL: #{image_url})"
      else
        puts "Image already exists for car: #{car.id} (URL: #{image_url})"
      end
    end
  end

  def update_extras_for_car(car, node)
    extras_string = node.at_xpath('extras').text
    puts "Extras from XML: #{extras_string}" # Логируем полученные данные
    extras_array = extras_string.split(',').map(&:strip)

    # Удаляем старые комплектации, если они отсутствуют в новых данных
    car.extras.each do |extra|
      unless extras_array.include?(extra.extra_name.name)
        extra.destroy
        puts "Extra removed for car: #{car.id}"
      end
    end

    # Добавляем новые комплектации
    extras_array.each do |extra|
      extra_name_record = ExtraName.find_or_create_by(name: extra)
      unless car.extras.exists?(extra_name: extra_name_record)
        category_name = determine_category(extra)
        category = Category.find_or_create_by(name: category_name)
        new_extra = Extra.create(car: car, category: category, extra_name: extra_name_record)
        if new_extra.persisted?
          puts "Extra added for car: #{car.id} (Extra: #{extra})"
        else
          puts "Failed to add extra for car: #{car.id} (Extra: #{extra})"
          puts new_extra.errors.full_messages.join(", ")
        end
      else
        puts "Extra already exists for car: #{car.id} (Extra: #{extra})"
      end
    end
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
end
