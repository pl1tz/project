json.extract! car_catalog_configuration, :id, :car_catalog_id, :package_group, :package_name, :volume, :transmission, :power, :price, :credit_discount, :trade_in_discount, :recycling_discount, :special_price, :created_at, :updated_at
json.url car_catalog_configuration_url(car_catalog_configuration, format: :json)
