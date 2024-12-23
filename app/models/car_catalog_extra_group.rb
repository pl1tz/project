class CarCatalogExtraGroup < ApplicationRecord
    has_many :car_catalog_extras, dependent: :destroy
end
