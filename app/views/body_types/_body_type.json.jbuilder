json.extract! body_type, :id, :name, :created_at, :updated_at
json.url body_type_url(body_type, format: :json)
