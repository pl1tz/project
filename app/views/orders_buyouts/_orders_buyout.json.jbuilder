json.extract! orders_buyout, :id, :buyout_id, :order_status_id, :description, :created_at, :updated_at
json.url orders_buyout_url(orders_buyout, format: :json)
