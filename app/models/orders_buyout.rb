class OrdersBuyout < ApplicationRecord
  belongs_to :buyout, dependent: :destroy
  belongs_to :order_status
end
