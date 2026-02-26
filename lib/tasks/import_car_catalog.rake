require 'nokogiri'
require 'open-uri'
require 'httparty'

namespace :import_catalog do

  task delete_car_catalog: :environment do
    ActiveRecord::Base.transaction do
      CarCatalogExtra.destroy_all
      puts "delete Extra"
      CarCatalogExtraGroup.destroy_all
      puts "delete Group"
      CarCatalogExtraName.destroy_all
      puts "delete Name"
      CarCatalogConfiguration.destroy_all
      puts "delete Configuration"
      CarCatalog.destroy_all
      puts "Car data destroy successfully."
    end
  end

  task create_car_catalog: :environment do
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

        car_catalog = CarCatalog.find_or_create_by!(
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

          CarCatalogContent.find_or_create_by!(
            car_catalog: car_catalog,
            content: content_text
          )
        end

        # Сохранение технических данных
        save_techno_data_for_car(car_catalog.id, document)

        import_engine_data(car_catalog.id, document)

        parse_car_images(car_catalog.id, document)

        parse_car_configuration_and_extra(car_catalog.id, document)

        save_car_colors(car_catalog.id, document)

        puts "Car data imported successfully for #{brand} #{model}."
      end
    end
  end

  # Скачивает только картинки для машин, которые уже есть в БД. Новые машины не добавляет.
  task refresh_images: :environment do
    base_url = 'https://center-auto.ru'
    catalog_url = "#{base_url}/katalog"

    catalog_response = HTTParty.get(catalog_url)
    catalog_document = Nokogiri::HTML(catalog_response.body)
    car_links = catalog_document.css('.catalog .item ul li a').map { |link| link['href'] }

    car_links.each do |car_link|
      car_url = car_link.start_with?('http') ? car_link : "#{base_url}#{car_link}"
      response = HTTParty.get(car_url)
      document = Nokogiri::HTML(response.body)

      data_name = document.at_css('h1')&.text&.strip
      next unless data_name

      first_word, *remaining_words = data_name.split
      remaining_text = remaining_words.join(' ')
      brand = first_word
      model = remaining_text

      car_catalog = CarCatalog.find_by(brand: brand, model: model)
      unless car_catalog
        puts "Пропуск (нет в БД): #{brand} #{model}"
        next
      end

      save_techno_data_for_car(car_catalog.id, document)
      parse_car_images(car_catalog.id, document)
      save_car_colors(car_catalog.id, document)

      puts "Картинки обновлены: #{brand} #{model}."
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
    domain_url = 'https://automagnat.ru' # Ваш домен
    images_directory = Rails.root.join('public', 'uploads', 'images') # Папка для сохранения изображений

    # Создаем директорию, если она не существует
    FileUtils.mkdir_p(images_directory)

    # Обновляем URL, если он содержит '/mini'
    if image_url.include?('/mini')
      image_url.gsub!('/mini', '') # Удаляем '/mini' иновз URL
    end

    all_catalog_url = "#{base_url}#{URI::DEFAULT_PARSER.escape(image_url)}"

    # Сохраняем изображение на сервере
    image_data = URI.open(all_catalog_url).read
    image_filename = File.basename(image_url)
    image_path = images_directory.join(image_filename)

    File.open(image_path, 'wb') do |file|
      file.write(image_data)
    end

    # Сохраняем путь к изображению в базе данных
    CarCatalogTexno.find_or_create_by!(
      car_catalog_id: car_catalog_id,
      image: "#{domain_url}/uploads/images/#{image_filename}",
      width: width,
      height: height,
      length: length
    )

    puts "Techno data saved for car catalog: #{car_catalog_id}"
  end

  def save_car_colors(car_catalog_id, document)
    base_url = 'https://center-auto.ru'
    domain_url = 'https://automagnat.ru'
    images_directory = Rails.root.join('public', 'uploads', 'images')
    FileUtils.mkdir_p(images_directory)

    document.css('.top__car-color .thumbnail').each do |color_node|
      background_match = color_node['style']&.match(/background: (#[0-9a-fA-F]{6})/)
      background = background_match ? background_match[1] : nil
      name = color_node['data-title']&.strip
      image_path = color_node['data-image']
      next unless image_path

      image_url = "#{base_url}#{URI::DEFAULT_PARSER.escape(image_path)}"
      begin
        image_data = URI.open(image_url).read
        image_filename = File.basename(image_path)
        image_file_path = images_directory.join(image_filename)

        File.open(image_file_path, 'wb') { |file| file.write(image_data) }
        image = "#{domain_url}/uploads/images/#{image_filename}"

        CarColor.find_or_create_by!(
          car_catalog_id: car_catalog_id,
          background: background,
          name: name,
          image: image
        )
      rescue OpenURI::HTTPError => e
        puts "Ошибка при загрузке изображения: #{e.message}"
      rescue StandardError => e
        puts "Общая ошибка: #{e.message}"
      end
    end
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
      CarCatalogEngine.find_or_create_by!(
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
    domain_url = 'https://automagnat.ru' # Ваш домен
    images_directory = Rails.root.join('public', 'uploads', 'images') # Папка для сохранения изображений

    # Создаем директорию, если она не существует
    FileUtils.mkdir_p(images_directory)

    # Извлекаем изображения экстерьера
    exterior_images = document.css('.photos .exterior .image img').map { |img| img['src'] }
    exterior_images.each do |image_url|
      if image_url.include?('/mini')
        image_url.gsub!('/mini', '') # Удаляем '/mini' из URL
      end
      all_catalog_url = "#{base_url}#{URI::DEFAULT_PARSER.escape(image_url)}"

      # Проверяем, является ли URL валидным
      begin
        URI.parse(all_catalog_url) # Проверка на валидность URL
        # Сохраняем изображение на сервере
        image_data = URI.open(all_catalog_url).read
        image_filename = File.basename(image_url)
        image_path = images_directory.join(image_filename)

        File.open(image_path, 'wb') do |file|
          file.write(image_data)
        end

        # Сохраняем путь к изображению в базе данных
        CarCatalogImage.find_or_create_by!(car_catalog_id: car_catalog_id, url: "#{domain_url}/uploads/images/#{image_filename}")
      rescue URI::InvalidURIError => e
        puts "Ошибка: Неверный URL - #{all_catalog_url}: #{e.message}"
      rescue OpenURI::HTTPError => e
        puts "Ошибка при загрузке изображения: #{e.message}"
      rescue StandardError => e
        puts "Общая ошибка: #{e.message}"
      end
    end

    # Извлекаем изображения интерьера
    interior_images = document.css('.photos .interior .image img').map { |img| img['src'] }
    interior_images.each do |image_url|
      if image_url.include?('/mini')
        image_url.gsub!('/mini', '') # Удаляем '/mini' из URL
      end
      all_catalog_url = "#{base_url}#{image_url}"

      # Проверяем, является ли URL валидным
      begin
        URI.parse(all_catalog_url) # Проверка на валидность URL
        # Сохраняем изображение на сервере
        image_data = URI.open(all_catalog_url).read
        image_filename = File.basename(image_url)
        image_path = images_directory.join(image_filename)

        File.open(image_path, 'wb') do |file|
          file.write(image_data)
        end

        # Сохраняем путь к изображению в базе данных
        CarCatalogImage.find_or_create_by!(car_catalog_id: car_catalog_id, url: "#{domain_url}/uploads/images/#{image_filename}")
      rescue URI::InvalidURIError => e
        puts "Ошибка: Неверный URL - #{all_catalog_url}: #{e.message}"
      rescue OpenURI::HTTPError => e
        puts "Ошибка при загрузке изображения: #{e.message}"
      rescue StandardError => e
        puts "Общая ошибка: #{e.message}"
      end
    end

    puts "Images saved for car catalog: #{car_catalog_id}"
  end

  def parse_car_configuration_and_extra(car_catalog_id, document)
    prices_table = document.at_css('.prices table')
    return unless prices_table 
  
    # Извлечение скидок из checkbox-elem
    credit_discount = document.at_css('label.checkbox-elem:nth-of-type(1) .check-title span')&.text&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '')&.to_i } || 0
    trade_in_discount = document.at_css('label.checkbox-elem:nth-of-type(2) .check-title span')&.text&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '')&.to_i } || 0
    recycling_discount = document.at_css('label.checkbox-elem:nth-of-type(3) .check-title span')&.text&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '')&.to_i } || 0
  
    rows = prices_table.css('tr')
    current_package_group = nil
    configurations = []
    last_car_catalog_configuration = nil
  
    # Собираем конфигурации
    rows.each do |row|
      if row['class']&.include?('group-name')
        current_package_group = row.at_css('td')&.text&.strip
      elsif row['class']&.include?('compl-height')
        configurations << { row: row, group: current_package_group, type: :compl_height }
      elsif row['class']&.include?('compl-content')
        configurations << { row: row, group: current_package_group, type: :compl_content }
      end
    end
  
    # Обрабатываем конфигурации
    configurations.each do |config|
      if config[:type] == :compl_height
        row = config[:row]
        current_package_group = config[:group]
  
        title = row.at_css('.compl-title-main')&.text&.strip
        volume = row.at_css('td:nth-child(2)')&.text&.strip&.to_f
        gearbox = row.at_css('td:nth-child(3)')&.text&.strip&.to_f
        power = row.at_css('td:nth-child(4)')&.text&.strip&.then { |text| text&.gsub(' л.с.', '').to_i }
        price = row.at_css('td:nth-child(5)')&.text&.strip&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '').to_i }
        discount_price = row.at_css('td:nth-child(6) .compl-price')&.text&.strip&.then { |text| text&.gsub(' ₽', '')&.gsub(' ', '').to_i }
  
        # Расчет специальной цены
        special_price = price - (credit_discount + trade_in_discount + recycling_discount)
  
        # Создаем конфигурацию
        last_car_catalog_configuration = CarCatalogConfiguration.find_or_create_by!(
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
      elsif config[:type] == :compl_content
        # Если это `compl-content`, вызываем `parse_car_extras`
        if last_car_catalog_configuration
          parse_car_extras(last_car_catalog_configuration.id, config[:row])
        else
          puts "---Warning: #{config[:group]}"
        end
      end
    end

    puts "Techno data saved for car configuration and extra: #{car_catalog_id}"
  end

  def parse_car_extras(car_catalog_configuration_id, compl_content)
    return unless compl_content # Пропускаем, если нет `compl-content`
  
    current_group_id = nil  # Инициализация переменной для хранения текущей группы
    extra_table = compl_content.css('ul li')
  
    extra_table.each do |item|
      
      if item.attributes['class'] && item.attributes['class'].value.include?('compl-title')
        # Если элемент имеет класс 'compl-title', это заголовок новой группы
        current_group_name = item.text.strip
        current_group_id = get_or_create_extra_group(current_group_name)
      else
        # Если это не заголовок группы, то это элемент с дополнительной опцией
        extra_name = item.text.strip
        extra_name_record = get_or_create_extra_name(extra_name)
  
        # Проверяем, если текущая группа была найдена
        if current_group_id
          unless CarCatalogExtra.exists?(
            car_catalog_configuration_id: car_catalog_configuration_id,
            car_catalog_extra_group_id: current_group_id.id,
            car_catalog_extra_name_id: extra_name_record.id
          )
            CarCatalogExtra.find_or_create_by!(
              car_catalog_configuration_id: car_catalog_configuration_id,
              car_catalog_extra_group_id: current_group_id.id,
              car_catalog_extra_name_id: extra_name_record.id
            )
          else
            puts "+++Duplicate extra found for #{extra_name}"
          end
        else
          puts "---Warning: No current group ID found for extra: #{extra_name}"
        end
      end
    end
  end

  def get_or_create_extra_group(name)
    CarCatalogExtraGroup.find_or_create_by!(name: name)
  end

  def get_or_create_extra_name(name)
    CarCatalogExtraName.find_or_create_by!(name: name)
  end
end
