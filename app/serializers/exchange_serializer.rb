class ExchangeSerializer < ActiveModel::Serializer
  attributes :id, :car_id, :customer_car, :name, :phone, :credit_term, :initial_contribution
  has_one :car
end
