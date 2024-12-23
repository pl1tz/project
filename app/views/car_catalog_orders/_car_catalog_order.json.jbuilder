json.extract! car_catalog_order, :id, :car_catalog_id, :name, :phone, :created_at, :updated_at
json.url car_catalog_order_url(car_catalog_order, format: :json)
