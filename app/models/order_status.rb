class OrderStatus < ApplicationRecord
    has_many :car_catalog_orders, dependent: :destroy
end
