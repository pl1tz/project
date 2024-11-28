require 'open-uri'
require 'prawn'
require 'prawn/table'


class ReportsController < ApplicationController

  def show
    @car = Car.find(params[:id]) # Предполагается, что у вас есть модель Car
    generate_pdf(@car)
  end

  private

  def generate_pdf(car)
    Prawn::Document.generate("car_report_#{car.id}.pdf") do
      font_families.update('TimesNewRoman' => {
        normal: { file: 'app/assets/fonts/Inter.ttf' },
        bold: { file: 'app/assets/fonts/Inter.ttf' }
      })

      font 'TimesNewRoman'

      text "Проверка истории автомобиля по VIN", size: 10, style: :bold
      text "Отчёт по истории эксплуатации автомобиля по VIN", size: 10, style: :bold
      move_down 20
      text "Отчёт от #{Date.today.strftime('%d %B %Y')} г.", size: 10
      move_down 5
      text "#{car.brand.name} #{car.model.name}, #{car.year}", size: 16, style: :bold
      move_down 10

      # Добавьте изображение автомобиля, если оно доступно
      if car.images.any?
        begin
          image_data = URI.open(car.images.first.url).read
          image StringIO.new(image_data), width: 400, height: 300 # Используем первое изображение
          move_down 20
        rescue OpenURI::HTTPError => e
          puts "Ошибка при загрузке изображения: #{e.message}"
          text "Изображение недоступно: #{e.message}", size: 12
        rescue Errno::ENOENT => e
          puts "Ошибка: #{e.message}"
          text "Изображение не найдено: #{e.message}", size: 12
        rescue StandardError => e
          puts "Общая ошибка: #{e.message}"
          text "Ошибка при загрузке изображения: #{e.message}", size: 12
        end
      end

      # Создание данных для таблицы
      table_data = [
        ["VIN:", "#{car.history_car.vin[0..5]}*****#{car.history_car.vin[-4..-1]}"], # Скрываем часть VIN
        ["Госномер:", car.history_car.registration_number || 'Отсутствует'],
        ["Номер кузова:", car.history_car.vin],
        ["Год выпуска:", car.year],
        ["Тип ТС:", car.body_type.name],
        ["Цвет:", car.color.name],
        ["Объём двигателя:", "#{car.engine_capacity_type.capacity} л."],
        ["Мощность:", "#{car.engine_power_type.power} л.с."]
      ]

      # Создание таблицы
      table(table_data, width: bounds.width) do
        row(0).font_style = :bold # Сделать первую строку жирной
        self.header = true
        self.cell_style = { size: 12, padding: 5 }
        self.row_colors = ['FFFFFF', 'F0F0F0'] # Чередование цветов строк
      end

      text "VIN скрыт для из соображений безопасности", size: 12, align: :left
      move_down 20

      start_new_page

      # Сводка по автомобилю
      text "Сводка по автомобилю", size: 16, style: :bold, align: :left
      move_down 5

      # Пример сводки
      text "#{car.history_car.registration_restrictions}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.registration_restrictions_info}", size: 9
      move_down 10
      text "#{car.history_car.wanted_status}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.wanted_status_info}", size: 9
      move_down 10
      text "#{car.history_car.pledge_status}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.pledge_status_info}", size: 9
      move_down 10
      text "#{car.history_car.previous_owners} владельцев по ПТС", size: 12, style: :bold
      move_down 10
      text "#{car.history_car.accidents_found}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.accidents_found_info}", size: 9
      move_down 10
      text "#{car.history_car.repair_estimates_found}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.repair_estimates_found_info}", size: 9
      move_down 10
      text "#{car.history_car.taxi_usage}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.taxi_usage_info}", size: 9
      move_down 10
      text "#{car.history_car.carsharing_usage}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.carsharing_usage_info}", size: 9
      move_down 10
      text "#{car.history_car.diagnostics_found}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.diagnostics_found_info}", size: 9
      move_down 10
      text "#{car.history_car.technical_inspection_found}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.technical_inspection_found_info}", size: 9
      move_down 10
      text "#{car.history_car.imported}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.imported_info}", size: 9
      move_down 10
      text "#{car.history_car.insurance_found}", size: 12, style: :bold
      move_down 10
      text "#{car.history_car.recall_campaigns_found}", size: 12, style: :bold
      move_down 5
      text "#{car.history_car.recall_campaigns_found_info}", size: 9
      move_down 20

      # Заключение
      text "Проверка истории автомобиля по VIN", size: 12, align: :center
    end

    send_file "car_report_#{car.id}.pdf", type: 'application/pdf', disposition: 'inline'
  end
end
