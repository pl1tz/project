class OrdersCredit < ApplicationRecord
  belongs_to :credit
  belongs_to :order_status
end
