class OrdersCallRequestSerializer < ActiveModel::Serializer
  attributes :id, :description
  has_one :call_request
  has_one :order_status
end
