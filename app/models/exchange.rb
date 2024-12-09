class Exchange < ApplicationRecord
  belongs_to :car
  has_many :orders_exchange, dependent: :destroy
end
