class Installment < ApplicationRecord
    belongs_to :car
    has_many :orders_installment, dependent: :destroy
end
