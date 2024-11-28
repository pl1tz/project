class BuyoutSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :brand, :model, :year, :mileage
end
