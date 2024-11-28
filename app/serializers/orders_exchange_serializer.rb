class OrdersExchangeSerializer < ActiveModel::Serializer
  attributes :id, :description
  belongs_to :exchange
  belongs_to :order_status
end
