class CarCatalog < ApplicationRecord
    has_many :car_colors, dependent: :destroy
end
