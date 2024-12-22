class CarCatalogExtraSerializer < ActiveModel::Serializer
  attributes :id
  has_one :car_catalog_configuration
  has_one :car_catalog_extra_group
  has_one :car_catalog_extra_name
end
