json.extract! orders_installment, :id, :installment_id, :order_status_id, :description, :created_at, :updated_at
json.url orders_installment_url(orders_installment, format: :json)
