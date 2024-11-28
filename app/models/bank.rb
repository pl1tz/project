class Bank < ApplicationRecord
    has_many :programs, dependent: :destroy
end

