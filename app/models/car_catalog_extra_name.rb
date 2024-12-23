class CarCatalogExtraName < ApplicationRecord
    has_many :car_catalog_extras, dependent: :destroy
end
