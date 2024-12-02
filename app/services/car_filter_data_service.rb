class CarFilterDataService
  def self.call(filters = {})
    cars = Car.all
    cars = apply_filters(cars, filters)
    all_brands = Car.joins(:brand).distinct.pluck('brands.name').sort

    # Получаем модели для выбранного бренда, если он выбран
    selected_brand_models = filters[:brand_name].present? ? Model.joins(:brand).where('brands.name = ?', filters[:brand_name]).distinct.pluck('models.name').sort : []
    selected_model_generations = filters[:model_name].present? ? Generation.joins(:model).where('models.name = ?', filters[:model_name]).distinct.pluck('generations.name').sort : []

    # Получаем доступные значения для различных параметров
    available_years = fetch_available_values(cars, filters, :year)
    available_prices = fetch_available_values(cars, filters, :price)
    available_gearbox_types = fetch_available_values(cars, filters, :gearbox_type_name)
    available_body_types = fetch_available_values(cars, filters, :body_type_name)
    available_drive_types = fetch_available_values(cars, filters, :drive_type_name)
    available_owners_count = fetch_available_values(cars, filters, :owners_count)
    available_engine_types = fetch_available_values(cars, filters, :engine_name_type_name)

    # Получаем количество машин после применения фильтров
    car_count = cars.count

    [
      { key: :car_count, value: car_count },
      { key: :brand_name, values: all_brands },
      { key: :model_name, values: selected_brand_models.empty? ? ['Все модели'] : selected_brand_models },
      { key: :generation_name, values: selected_model_generations.empty? ? ['Поколения'] : selected_model_generations },
      { key: :year_from, values: available_years },
      { key: :max_price, values: available_prices },
      { key: :gearbox_type_name, values: available_gearbox_types },
      { key: :body_type_name, values: available_body_types },
      { key: :drive_type_name, values: available_drive_types },
      { key: :owners_count, values: available_owners_count },
      { key: :engine_name_type_name, values: available_engine_types }
    ]
  end

  private

  def self.apply_filters(cars, filters)
    cars = cars.by_brand_name(filters[:brand_name]) if filters[:brand_name].present?
    cars = cars.by_model_name(filters[:model_name]) if filters[:model_name].present?
    cars = cars.by_generation(filters[:generation_name]) if filters[:generation_name].present?
    cars = cars.by_year_from(filters[:year_from]) if filters[:year_from].present?
    cars = cars.by_price(filters[:max_price]) if filters[:max_price].present?
    cars = cars.by_gearbox_type(filters[:gearbox_type_name]) if filters[:gearbox_type_name].present?
    cars = cars.by_body_type(filters[:body_type_name]) if filters[:body_type_name].present?
    cars = cars.by_drive_type(filters[:drive_type_name]) if filters[:drive_type_name].present?
    cars = cars.by_owners_count(filters[:owners_count]) if filters[:owners_count].present?
    cars = cars.by_engine_name_type(filters[:engine_name_type_name]) if filters[:engine_name_type_name].present?

    cars
  end

  def self.fetch_available_values(cars, filters, value_type)
    case value_type
    when :year
      # Логика для получения доступных годов
      if filters[:generation_name].present?
        Generation.joins(:cars).where('generations.name = ?', filters[:generation_name]).distinct.pluck('cars.year').sort
      elsif filters[:model_name].present?
        Model.joins(:cars).where('models.name = ?', filters[:model_name]).distinct.pluck('cars.year').sort
      elsif filters[:brand_name].present?
        Brand.joins(models: :cars).where('brands.name = ?', filters[:brand_name]).distinct.pluck('cars.year').sort
      else
        cars.distinct.pluck(:year).sort
      end
    when :price
      # Используем логику fetch_price_ranges для получения диапазона цен
      if filters[:generation_name].present?
        cars = Generation.joins(:cars).where('generations.name = ?', filters[:generation_name]).distinct.pluck('cars.price')
      elsif filters[:model_name].present?
        cars = Model.joins(:cars).where('models.name = ?', filters[:model_name]).distinct.pluck('cars.price')
      elsif filters[:brand_name].present?
        cars = Brand.joins(models: :cars).where('brands.name = ?', filters[:brand_name]).distinct.pluck('cars.price')
      else
        cars = cars.distinct.pluck(:price)
      end
      fetch_price_ranges(cars, filters) # Используем метод для получения диапазона цен
    when :gearbox_type_name
      # Логика для получения доступных типов коробок передач
      if filters[:generation_name].present?
        Generation.joins(cars: :gearbox_type).where('generations.name = ?', filters[:generation_name]).distinct.pluck('gearbox_types.name').sort.uniq
      elsif filters[:model_name].present?
        Model.joins(cars: :gearbox_type).where('models.name = ?', filters[:model_name]).distinct.pluck('gearbox_types.name').sort.uniq
      elsif filters[:brand_name].present?
        Brand.joins(models: { cars: :gearbox_type }).where('brands.name = ?', filters[:brand_name]).distinct.pluck('gearbox_types.name').sort.uniq
      else
        cars.joins(:gearbox_type).distinct.pluck('gearbox_types.name').sort.uniq
      end
    when :body_type_name
      # Логика для получения доступных типов кузовов
      if filters[:generation_name].present?
        Generation.joins(cars: :body_type).where('generations.name = ?', filters[:generation_name]).distinct.pluck('body_types.name').sort.uniq
      elsif filters[:model_name].present?
        Model.joins(cars: :body_type).where('models.name = ?', filters[:model_name]).distinct.pluck('body_types.name').sort.uniq
      elsif filters[:brand_name].present?
        Brand.joins(models: { cars: :body_type }).where('brands.name = ?', filters[:brand_name]).distinct.pluck('body_types.name').sort.uniq
      else
        cars.joins(:body_type).distinct.pluck('body_types.name').sort.uniq
      end
    when :drive_type_name
      # Логика для получения доступных типов приводов
      if filters[:generation_name].present?
        Generation.joins(cars: :drive_type).where('generations.name = ?', filters[:generation_name]).distinct.pluck('drive_types.name').sort.uniq
      elsif filters[:model_name].present?
        Model.joins(cars: :drive_type).where('models.name = ?', filters[:model_name]).distinct.pluck('drive_types.name').sort.uniq
      elsif filters[:brand_name].present?
        Brand.joins(models: { cars: :drive_type }).where('brands.name = ?', filters[:brand_name]).distinct.pluck('drive_types.name').sort.uniq
      else
        cars.joins(:drive_type).distinct.pluck('drive_types.name').sort.uniq
      end
    when :owners_count
      # Логика для получения доступных количеств владельцев
      if filters[:generation_name].present?
        Generation.joins(cars: :history_cars).where('generations.name = ?', filters[:generation_name]).distinct.pluck('history_cars.previous_owners').sort.uniq
      elsif filters[:model_name].present?
        Model.joins(cars: :history_cars).where('models.name = ?', filters[:model_name]).distinct.pluck('history_cars.previous_owners').sort.uniq
      elsif filters[:brand_name].present?
        Brand.joins(models: { cars: :history_cars }).where('brands.name = ?', filters[:brand_name]).distinct.pluck('history_cars.previous_owners').sort.uniq
      else
        cars.joins(:history_cars).distinct.pluck('history_cars.previous_owners').sort.uniq
      end
    when :engine_name_type_name
      # Логика для получения доступных типов двигателей
      if filters[:generation_name].present?
        Generation.joins(cars: :engine_name_type).where('generations.name = ?', filters[:generation_name]).distinct.pluck('engine_name_types.name').sort.uniq
      elsif filters[:model_name].present?
        Model.joins(cars: :engine_name_type).where('models.name = ?', filters[:model_name]).distinct.pluck('engine_name_types.name').sort.uniq
      elsif filters[:brand_name].present?
        Brand.joins(models: { cars: :engine_name_type }).where('brands.name = ?', filters[:brand_name]).distinct.pluck('engine_name_types.name').sort.uniq
      else
        cars.joins(:engine_name_type).distinct.pluck('engine_name_types.name').sort.uniq
      end
    end
  end

  def self.fetch_price_ranges(cars, filters)
    # Определяем cars в зависимости от фильтров
    if filters[:generation_name].present?
      cars = Generation.joins(:cars).where('generations.name = ?', filters[:generation_name]).pluck('cars.price')
    elsif filters[:model_name].present?
      cars = Model.joins(:cars).where('models.name = ?', filters[:model_name]).pluck('cars.price')
    elsif filters[:brand_name].present?
      cars = Brand.joins(models: :cars).where('brands.name = ?', filters[:brand_name]).pluck('cars.price')
    else
      cars = Car.pluck(:price) # Извлекаем только цены
    end
  
    # Рассчитываем минимальную и максимальную цену
    min_price = 300_000
    max_price = cars.present? ? cars.map(&:to_f).max.ceil(-5) : min_price # Преобразуем в float перед вызовом ceil
  
    (min_price..max_price).step(100_000).to_a
  end
end 