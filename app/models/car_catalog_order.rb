class CarCatalogOrder < ApplicationRecord
  belongs_to :order_status
  belongs_to :car_catalog, foreign_key: :car_catalog, optional: true
end
