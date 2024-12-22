class CarCatalogExtra < ApplicationRecord
  belongs_to :car_catalog_configuration
  belongs_to :car_catalog_extra_group
  belongs_to :car_catalog_extra_name
end
