class OrdersExchange < ApplicationRecord
  belongs_to :exchange
  belongs_to :order_status
end
