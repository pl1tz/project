class OrdersCallRequest < ApplicationRecord
  belongs_to :call_request
  belongs_to :order_status
  has_one :car, through: :call_reques
end
