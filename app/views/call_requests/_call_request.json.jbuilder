json.extract! call_request, :id, :car_id, :name, :phone, :preferred_time, :created_at, :updated_at
json.url call_request_url(call_request, format: :json)
