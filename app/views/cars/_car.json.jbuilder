json.extract! car, :id, :model_id, :brand_id, :year, :price, :description, :color_id, :body_type_id, :engine_type_id, :gearbox_type_id, :drive_type_id, :fuel_type_id, :created_at, :updated_at
json.url car_url(car, format: :json)
