json.extract! orders_call_request, :id, :call_request_id, :order_status_id, :description, :created_at, :updated_at
json.url orders_call_request_url(orders_call_request, format: :json)
