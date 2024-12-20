require 'nokogiri'
require 'open-uri'
require 'httparty'

namespace :import do
  task create_cars: :environment do
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
  
  task delete_diff_cars: :environment do
    xml_data = URI.open('https://plex-crm.ru/xml/usecarmax/hpbz0dmc').read
    doc = Nokogiri::XML(xml_data)
    xml_unique_ids = doc.xpath('//car/unique_id').map(&:text)

    Car.where.not(unique_id: xml_unique_ids).destroy_all
    puts "Cars removed."  
  end

  task update_cars: :environment do
    xml_data = URI.open('https://plex-crm.ru/xml/usecarmax/hpbz0dmc').read
    doc = Nokogiri::XML(xml_data)

    ActiveRecord::Base.transaction do
      existing_cars = Car.includes(:history_cars, :images, :extras).all.index_by(&:unique_id)
      doc.xpath('//car').each do |node|
        unique_id_xml = node.at_xpath('unique_id').text
        # Поиск существующего автомобиля по unique_id
        car = Car.find_by(unique_id: unique_id_xml)
        if car
          puts "Car exists: #{unique_id_xml}"
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

  task update_all_cars: :environment do
    xml_data = URI.open('https://plex-crm.ru/xml/usecarmax/hpbz0dmc').read
    doc = Nokogiri::XML(xml_data)

    ActiveRecord::Base.transaction do
      existing_cars = Car.includes(:history_cars, :images, :extras).all.index_by(&:unique_id)
      doc.xpath('//car').each_slice(1000) do |car_nodes|  # Обработка по 100 узлов за раз
        car_nodes.each do |node|
          unique_id_xml = node.at_xpath('unique_id').text
          # Поиск существующего автомобиля по unique_id
          car = Car.find_by(unique_id: unique_id_xml)
          if car
            # Если автомобиль существует, обновляем его
            update_car_attributes(car, node)
            # Обновляем историю автомобиля
            update_history_attributes(car, node)
            # Обновляем изображения
            update_images_for_car(car, node)
            # Обновляем комплектацию
            update_extras_for_car(car, node)
            puts "Car update unique_id xml: #{unique_id_xml}"
          else
            puts "Car noexist: #{unique_id_xml}"
          end
        end
      end
    end
  end

  task destrroy_car_catalog: :environment do
    ActiveRecord::Base.transaction do
      CarCatalog.destroy_all
      puts "Car data destroy successfully."
    end
  end

  task careate_car_catalog: :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'httparty'
    base_url = 'https://center-auto.ru'
    catalog_url = "#{base_url}/katalog"

    # Получаем HTML-код страницы каталога
    catalog_response = HTTParty.get(catalog_url)
    catalog_document = Nokogiri::HTML(catalog_response.body)

    # Извлекаем ссылки на все машины
    car_links = catalog_document.css('.catalog .item ul li a').map { |link| link['href'] }

    car_links.each do |car_link|
      car_url = car_link.start_with?('http') ? car_link : "#{base_url}#{car_link}"
      response = HTTParty.get(car_url)
      document = Nokogiri::HTML(response.body)

      ActiveRecord::Base.transaction do
        data_name = document.at_css('h1').text.strip
        first_word, *remaining_words = data_name.split
        remaining_text = remaining_words.join(' ')
        brand = first_word
        model = remaining_text

        power_match = document.at_css('div:contains("Мощность двиг.")')&.text&.match(/(\d+) л.с./)
        power = power_match ? power_match[1].to_i : nil

        acceleration_match = document.at_css('div:contains("Разгон до 100км/ч")')&.text&.match(/(\d+\.\d+) с/)
        acceleration = acceleration_match ? acceleration_match[1].to_f : nil

        max_speed_match = document.at_css('div:contains("Макс. скорость")')&.text&.match(/(\d+) км\/ч/)
        max_speed = max_speed_match ? max_speed_match[1].to_i : nil

        car_catalog = CarCatalog.create!(
          brand: brand,
          model: model,
          power: power,
          acceleration: acceleration,
          max_speed: max_speed
        )

        # Парсим содержимое car__content-text
        content_nodes = document.css('.car__content-text p')
        content_nodes.each do |content_node|
          content_text = content_node.text.strip

          CarCatalogContent.create!(
            car_catalog: car_catalog,
            content: content_text
          )
        end

        # Сохранение технических данных
        save_techno_data_for_car(car_catalog.id, document)

        import_engine_data(car_catalog.id, document)

        parse_car_images(car_catalog.id, document)

        create_car_catalog_configurations_from_node(car_catalog.id, document)

        document.css('.top__car-color .thumbnail').each do |color_node|
          background_match = color_node['style']&.match(/background: (#[0-9a-fA-F]{6})/)
          background = background_match ? background_match[1] : nil
          name = color_node['data-title']&.strip
          image_path = color_node['data-image']
          image = "#{base_url}#{image_path}"

          CarColor.create!(
            car_catalog_id: car_catalog.id,
            background: background,
            name: name,
            image: image
          )
        end

        puts "Car data imported successfully for #{brand} #{model}."
      end
    end
  end

  def save_techno_data_for_car(car_catalog_id, document)
    techno_image_node = document.at_css('.techno-image')
    return unless techno_image_node

    image_url = techno_image_node.at_css('img')['src']
    width = techno_image_node.at_css('.techno-width')&.text&.to_i
    height = techno_image_node.at_css('.techno-height')&.text&.to_i
    length = techno_image_node.at_css('.techno-length')&.text&.to_i
    base_url = 'https://center-auto.ru'
    image = "#{base_url}#{image_url}"

    CarCatalogTexno.create!(
      car_catalog_id: car_catalog_id,
      image: image,
      width: width,
      height: height,
      length: length
    )

    puts "Techno data saved for car catalog: #{car_catalog_id}"
  end

  def import_engine_data(car_catalog_id, document)
    # Находим таблицу с данными двигателей
    engine_table = document.at_css('.engines table')
    return unless engine_table
  
    # Извлекаем строки таблицы
    rows = engine_table.css('tr')
  
    # Заголовки двигателей (названия двигателей)
    engine_names = rows[0].css('th').map(&:text).reject(&:empty?)
  
    # Извлекаем данные из строк таблицы
    torque_row = rows.find { |row| row.at_css('td')&.text&.include?('Крутящий момент') }
    power_row = rows.find { |row| row.at_css('td')&.text&.include?('Мощность двигателя') }
    cylinders_row = rows.find { |row| row.at_css('td')&.text&.include?('Количество цилиндров') }
    volume_row = rows.find { |row| row.at_css('td')&.text&.include?('Объем двигателя') }
    fuel_row = rows.find { |row| row.at_css('td')&.text&.include?('Рекомендуемое топливо') }
    type_row = rows.find { |row| row.at_css('td')&.text&.include?('Тип двигателя') }
  
    # Проходим по каждому двигателю и сохраняем данные
    engine_names.each_with_index do |engine_name, index|
      CarCatalogEngine.create!(
        car_catalog_id: car_catalog_id,
        name_engines: engine_name.strip,
        torque: torque_row&.css('td')[index + 1]&.text&.to_i,
        power: power_row&.css('td')[index + 1]&.text&.to_i,
        cylinders: cylinders_row&.css('td')[index + 1]&.text&.to_i,
        engine_volume: volume_row&.css('td')[index + 1]&.text&.gsub(',', '.').to_f,
        fuel_type: fuel_row&.css('td')[index + 1]&.text&.strip,
        engine_type: type_row&.css('td')[index + 1]&.text&.strip
      )
    end
  
    puts "Engine data saved for car catalog: #{car_catalog_id}"
  end 

  def parse_car_images(car_catalog_id, document)
    base_url = 'https://center-auto.ru'
    
    # Извлекаем изображения экстерьера
    exterior_images = document.css('.photos .exterior .image img').map { |img| img['src'] }
    exterior_images.each do |image_url|
      all_catalog_url = "#{base_url}#{image_url}"
      CarCatalogImage.create!(
        car_catalog_id: car_catalog_id,
        url: all_catalog_url
      )
    end
  
    # Извлекаем изображения интерьера
    interior_images = document.css('.photos .interior .image img').map { |img| img['src'] }
    interior_images.each do |image_url|
      all_catalog_url = "#{base_url}#{image_url}"
      CarCatalogImage.create!(
        car_catalog_id: car_catalog_id,
        url: all_catalog_url
      )
    end
    
    puts "Images saved for car catalog: #{car_catalog_id}"
  end


  def create_car_catalog_configurations_from_node(car_catalog_id, document)
    configurations = document.css('.prices tr.compl-height.compl-wrap')
    package_groups = document.css('.prices tr.group-name').map { |group| group.at_css('td')&.text&.strip }

    # Извлечение скидок из checkbox-elem
    credit_discount = document.at_css('label.checkbox-elem:nth-of-type(1) .check-title span')&.text&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '')&.to_i } || 0
    trade_in_discount = document.at_css('label.checkbox-elem:nth-of-type(2) .check-title span')&.text&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '')&.to_i } || 0
    recycling_discount = document.at_css('label.checkbox-elem:nth-of-type(3) .check-title span')&.text&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '')&.to_i } || 0

    current_package_group = nil
    configurations.each_with_index do |config, index|
        # Проверяем, есть ли группа пакетов для текущей конфигурации
        if index < package_groups.size
            current_package_group = package_groups[index]
        end

        title = config.at_css('.compl-title-main')&.text&.strip
        volume = config.at_css('td:nth-child(2)')&.text&.strip&.to_f
        gearbox = config.at_css('td:nth-child(3)')&.text&.strip
        power = config.at_css('td:nth-child(4)')&.text&.strip&.then { |text| text&.gsub(' л.с.', '').to_i }
        price = config.at_css('td:nth-child(5)')&.text&.strip&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '').to_i }
        discount_price = config.at_css('td:nth-child(6) .compl-price')&.text&.strip&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '').to_i }

        # Расчет специальной цены
        special_price = price - credit_discount + trade_in_discount + recycling_discount

        puts "Saving configuration: #{title}, Volume: #{volume}, Gearbox: #{gearbox}, Power: #{power}, Price: #{price}, Discount Price: #{discount_price}, Special Price: #{special_price}, Package Group: #{current_package_group}, Credit Discount: #{credit_discount}, Trade-in Discount: #{trade_in_discount}, Recycling Discount: #{recycling_discount}"

        CarCatalogConfiguration.create!(
            car_catalog_id: car_catalog_id,
            package_group: current_package_group,
            package_name: title,
            volume: volume,
            transmission: gearbox,
            power: power,
            price: price,
            credit_discount: credit_discount,
            trade_in_discount: trade_in_discount,
            recycling_discount: recycling_discount,
            special_price: special_price
        )
    end
  end
  
  
  def update_car_attributes(car, node)
    attributes = {
      id: car.id,
      year: node.at_xpath('year').text.to_i,
      price: node.at_xpath('price').text.to_d,
      description: node.at_xpath('modification_id').text,
      color_id: Color.find_or_create_by(name: node.at_xpath('color').text).id,
      body_type_id: BodyType.find_or_create_by(name: node.at_xpath('body_type').text).id,
      engine_name_type_id: EngineNameType.find_or_create_by(name: node.at_xpath('engine_type').text).id,
      engine_power_type_id: EnginePowerType.find_or_create_by(power: node.at_xpath('engine_power').text.to_i).id,
      engine_capacity_type_id: find_or_create_engine_capacity_type(node).id,
      gearbox_type_id: find_or_create_gearbox_type(node).id,
      drive_type_id: DriveType.find_or_create_by(name: node.at_xpath('drive')&.text || "Полный").id,
      complectation_name: node.at_xpath('complectation_name').text
    }

    car.update(attributes)
  end

  def update_history_attributes(car, node)
    # Удаляем все существующие истории для автомобиля
    car.history_cars.destroy_all

    vin = node.at_xpath('vin').text

    owners_number_text = node.at_xpath('owners_number').text.downcase.split.first
    text_to_number = {
      "ноль" => 0, "один" => 1, "два" => 2, "три" => 3, "четыре" => 4,
      "пять" => 5, "шесть" => 6, "семь" => 7, "восемь" => 8, "девять" => 9, "десять" => 10
    }
    owners_number = text_to_number[owners_number_text] || owners_number_text.scan(/\d+/).first.to_i

    run_value = node.at_xpath('run')&.text
    params_last_mileage = (run_value && run_value.match?(/^\d+$/)) ? run_value.to_i : 10

    history_car = HistoryCar.create!(
      car_id: car.id,
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
      puts "History updated for car: #{vin}"
    else
      puts "History not created for car VIN: #{vin}"
      puts "Errors: #{history_car.errors.full_messages.join(", ")}"
    end
  end

  def update_images_for_car(car, node)
    # Удаляем все существующие изображения
    car.images.destroy_all

    # Создаем новые изображения
    node.xpath('images/image').each do |image_node|
      car.images.create(url: image_node.text)
      puts "Images update"
    end
  end

  def update_extras_for_car(car, node)
    extras_string = node.at_xpath('extras').text
    puts "Extras from XML: #{extras_string}" # Логируем полученные данные
    extras_array = extras_string.split(',').map(&:strip)

    # Удаляем все старые комплектации
    car.extras.destroy_all
    puts "All extras removed for car: #{car.id}"

    # Добавляем новые комплектации
    extras_array.each do |extra|
      extra_name_record = ExtraName.find_or_create_by(name: extra)
      category_name = determine_category(extra)
      category = Category.find_or_create_by(name: category_name)
      new_extra = Extra.create(car: car, category: category, extra_name: extra_name_record)

      if new_extra.persisted?
        puts "Extra added for car: #{car.id} (Extra: #{extra})"
      else
        puts "Failed to add extra for car: #{car.id} (Extra: #{extra})"
        puts new_extra.errors.full_messages.join(", ")
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
  
    # Полчаем текстовое значение элемента 'run'
    run_value = node.at_xpath('run')&.text

    # Проверяем, является ли значение числом, и устанавливаем params_last_mileage
    params_last_mileage = (run_value && run_value.match?(/^\d+$/)) ? run_value.to_i : 10
  
    history_car = HistoryCar.create!(
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
      accidents_found_info: "В отчёт не попадут аварии, которые произошли раньше 2015 года или не оформлял��сь в ГИБДД.",
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


end
