class CarCatalogImageSerializer < ActiveModel::Serializer
  attributes :id, :url
  has_one :car_catalog
end
