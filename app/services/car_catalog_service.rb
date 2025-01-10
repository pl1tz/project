class CarCatalogService

  def self.all_catalog
    CarCatalog.all.group_by { |car| car.brand }.sort.to_h.map do |brand, cars|
      {
        brand: brand,
        cars: cars.map do |car|
          {
            id: car.id,
            brand: car.brand,
            model: car.model,
            power: car.power,
            acceleration: car.acceleration,
            consumption: car.consumption,
            car_color: car.car_colors.first ? { id: car.car_colors.first.id, image: car.car_colors.first.image } : nil
          }
        end,
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

    def self.find_car_by_id(car_id)
      car = CarCatalog.includes(
        :car_colors,
        :car_catalog_contents,
        :car_catalog_texnos,
        :car_catalog_engines,
        :car_catalog_images,
        :car_catalog_configurations
      ).find_by(id: car_id)

      return nil unless car

      [
        {
          id: car.id,
          brand: car.brand,
          model: car.model,
          power: car.power,
          acceleration: car.acceleration,
          consumption: car.consumption,
          max_speed: car.max_speed,
          car_colors: car.car_colors.map { |color| { id: color.id, background: color.background, name: color.name, image: color.image } },
          car_catalog_contents: car.car_catalog_contents,
          car_catalog_texnos: car.car_catalog_texnos.map { |texno| { id: texno.id, image: texno.image, width: texno.width, height: texno.height, length: texno.length } },
          car_catalog_engines: car.car_catalog_engines.map { |engine| { id: engine.id, name_engines: engine.name_engines, torque: engine.torque, power: engine.power, cylinders: engine.cylinders, engine_volume: engine.engine_volume, fuel_type: engine.fuel_type, engine_type: engine.engine_type } },
          car_catalog_images: car.car_catalog_images.map { |image| { id: image.id, url: image.url } },
          car_catalog_configurations: car.car_catalog_configurations.group_by(&:package_group).map do |group_name, configs|
            {
              package_group: group_name,
              configurations: configs.map do |config|

                {
                  id: config.id,
                  package_name: config.package_name,
                  volume: config.volume,
                  transmission: config.transmission,
                  power: config.power,
                  price: config.price,
                  credit_discount: config.credit_discount,
                  trade_in_discount: config.trade_in_discount,
                  recycling_discount: config.recycling_discount,
                  special_price: config.special_price,
                  car_catalog_extras: config.car_catalog_extras.includes(:car_catalog_extra_group, :car_catalog_extra_name).group_by(&:car_catalog_extra_group).map do |extra_group_name, extras|
                    {
                      group_name: extra_group_name,
                      extra_names: extras.map(&:car_catalog_extra_name).map(&:name)
                    }
                  end
                }
              end
            }
          end
        }
      ]
    end

    def self.find_configurations_by_id(car_catalog_id)

      configurations = CarCatalogConfiguration
        .where(car_catalog_id: car_catalog_id)
        .includes(car_catalog_extras: [:car_catalog_extra_group, :car_catalog_extra_name])

      grouped_data = configurations.map do |config|
        {
          package_name: config.package_name,
          volume: config.volume,
          power: config.power,
          special_price: config.special_price,
          package_name: config.package_name,
          extras: config.car_catalog_extras.group_by { |extra| extra.car_catalog_extra_group.name }.transform_values do |extras|
            extras.map { |extra| extra.car_catalog_extra_name.name }
          end
        }
      end

      groups = grouped_data.flat_map { |data| data[:extras].keys }.uniq
      features = grouped_data.flat_map { |data| data[:extras].values.flatten }.uniq
      {
        configurations: grouped_data.map do |config|
          {
            package_name: config[:package_name],
            volume: config[:volume],
            power: config[:power],
            special_price: config[:special_price]
          }
        end,
        groups: groups.map do |group|
          {
            group_name: group,
            features: features.map do |feature|
              {
                feature_name: feature,
                values: grouped_data.map do |data|
                  data[:extras][group]&.include?(feature) ? "+" : "-"
                end
              }
            end.select { |feature_data| feature_data[:values].include?("+") }
          }
        end
      }
    end

end