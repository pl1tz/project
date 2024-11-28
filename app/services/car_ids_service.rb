class CarIdsService
  def initialize(params)
    @params = params
  end

  def call
    return find_car_by_id if @params[:id].present?

    # Если id не указан, возвращаем пустой массив или сообщение об ошибке
    []
  end

  private

  def find_car_by_id
    car = Car.includes(:brand, :model, :generation, :color, :body_type, :engine_name_type, :engine_power_type, :engine_capacity_type, :gearbox_type, :drive_type).find_by(id: @params[:id])
    return {} unless car

    {
      id: car.id,
      year: car.year,
      price: car.price,
      description: car.description,
      online_view_available: car.online_view_available,
      complectation_name: car.complectation_name,
      brands: { id: car.brand.id, name: car.brand.name },  # Получаем id и name бренда
      models: { id: car.model.id, name: car.model.name },  # Получаем id и name модели
      generations: { id: car.generation.id, name: car.generation.name },  # Получаем id и name поколения
      gearbox_types: { id: car.gearbox_type.id, name: car.gearbox_type.name },  # Получаем id и name типа коробки передач
      body_types: { id: car.body_type.id, name: car.body_type.name },  # Получаем id и name типа кузова
      drive_types: { id: car.drive_type.id, name: car.drive_type.name },  # Получаем id и name типа привода
      engine_name_types: { id: car.engine_name_type.id, name: car.engine_name_type.name },  # Получаем id и name типа двигателя
      engine_power_types: { id: car.engine_power_type.id, power: car.engine_power_type.power },  # Получаем id и power типа двигателя
      engine_capacity_types: { id: car.engine_capacity_type.id, capacity: car.engine_capacity_type.capacity },  # Получаем id и capacity типа двигателя
      colors: { id: car.color.id, name: car.color.name },  # Получаем id и name цвета
      all_brands: Brand.includes(models: :generations).map { |brand| 
        {
          id: brand.id, 
          name: brand.name, 
          all_models: brand.models.map { |model| 
            {
              id: model.id, 
              name: model.name, 
              all_generations: model.generations.map { |generation| { id: generation.id, name: generation.name } }  # Вложенность поколений
            }
          }
        }
      },  # Получаем все поколения
      all_gearbox_types: GearboxType.all.map { |gearbox| { id: gearbox.id, name: gearbox.name } },  # Получаем все типы коробки передач
      all_body_types: BodyType.all.map { |body| { id: body.id, name: body.name } },  # Получаем все типы кузова
      all_drive_types: DriveType.all.map { |drive| { id: drive.id, name: drive.name } },  # Получаем все типы привода
      all_engine_name_types: EngineNameType.all.map { |engine| { id: engine.id, name: engine.name } },  # Получаем все типы двигателей
      all_engine_power_types: EnginePowerType.all.map { |engine| { id: engine.id, power: engine.power } },  # Получаем все типы двигателей
      all_engine_capacity_types: EngineCapacityType.all.map { |engine| { id: engine.id, capacity: engine.capacity.to_f } },  # Получаем все типы двигателей
      all_colors: Color.all.map { |color| { id: color.id, name: color.name } }  # Получаем все цвета
    }
  end
end 