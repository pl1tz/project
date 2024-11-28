class OrdersInstallmentSerializer < ActiveModel::Serializer
  attributes :id, :description
  has_one :installment
  has_one :order_status
end
