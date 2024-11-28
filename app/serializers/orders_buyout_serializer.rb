class OrdersBuyoutSerializer < ActiveModel::Serializer
  attributes :id, :description
  has_one :buyout
  has_one :order_status
end
