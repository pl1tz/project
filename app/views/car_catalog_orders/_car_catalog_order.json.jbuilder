json.extract! car_catalog_order, :id, :order_status_id, :car_catalog, :name, :phone, :created_at, :updated_at
json.url car_catalog_order_url(car_catalog_order, format: :json)
