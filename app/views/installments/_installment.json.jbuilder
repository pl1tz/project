json.extract! installment, :id, :car_id, :name, :phone, :credit_term, :initial_contribution, :created_at, :updated_at
json.url installment_url(installment, format: :json)
