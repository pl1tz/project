json.extract! car_catalog, :id, :brand, :model, :power, :acceleration, :consumption, :max_speed, :created_at, :updated_at
json.url car_catalog_url(car_catalog, format: :json)
