json.extract! orders_exchange, :id, :exchanges_id, :order_status_id, :description, :created_at, :updated_at
json.url orders_exchange_url(orders_exchange, format: :json)
