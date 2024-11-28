json.extract! orders_credit, :id, :credit_id, :order_status_id, :description, :created_at, :updated_at
json.url orders_credit_url(orders_credit, format: :json)
