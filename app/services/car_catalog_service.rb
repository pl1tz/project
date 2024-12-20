class CarCatalogService
    def self.all_catalog
        CarCatalog.all.group_by { |car| car.brand }.sort.to_h.map do |brand, cars|
            {
              brand: brand,
              models_count: cars.uniq { |car| car.model }.count,
              models: cars.map { |car| { id: car.id, model: car.model } }.uniq.sort_by { |car| car[:model] }
            }
        end
    end

    def self.cars_by_brand(brand_name)
      CarCatalog.includes(:car_colors)  # Подключаем цвета автомобиля
                .where(brand: brand_name)
                .map do |car|
                  {
                    id: car.id,
                    brand: car.brand,
                    model: car.model,
                    power: car.power,
                    acceleration: car.acceleration,
                    consumption: car.consumption,
                    car_color: car.car_colors.first ? { id: car.car_colors.first.id, image: car.car_colors.first.image } : nil
                  }
                end
    end
  end