class OrdersBuyout < ApplicationRecord
  belongs_to :buyout
  belongs_to :order_status
end
