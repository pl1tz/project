json.extract! image, :id, :car_id, :url, :description, :is_primary, :created_at, :updated_at
json.url image_url(image, format: :json)
