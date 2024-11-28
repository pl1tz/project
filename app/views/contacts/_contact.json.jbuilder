json.extract! contact, :id, :phone, :mode_operation, :auto_address, :status, :created_at, :updated_at
json.url contact_url(contact, format: :json)
