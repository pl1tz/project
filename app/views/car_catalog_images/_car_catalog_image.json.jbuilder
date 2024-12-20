json.extract! car_catalog_image, :id, :car_catalog_id, :url, :created_at, :updated_at
json.url car_catalog_image_url(car_catalog_image, format: :json)
