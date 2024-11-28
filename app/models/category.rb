class Category < ApplicationRecord
    has_many :extras
    has_many :cars, through: :extras
end
