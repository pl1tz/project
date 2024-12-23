class CarCatalogOrderSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone
  has_one :car_catalog
end
