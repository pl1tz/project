class Credit < ApplicationRecord
    belongs_to :car
    belongs_to :bank, optional: true
    belongs_to :program, optional: true
    has_many :orders_credit, dependent: :destroy
end
