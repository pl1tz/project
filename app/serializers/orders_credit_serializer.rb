class OrdersCreditSerializer < ActiveModel::Serializer
  attributes :id, :description
  has_one :credit
  has_one :order_status

end
