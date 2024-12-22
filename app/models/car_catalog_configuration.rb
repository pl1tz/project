class CarCatalogConfiguration < ApplicationRecord
  belongs_to :car_catalog
  has_many :car_catalog_extras, dependent: :destroy
end
