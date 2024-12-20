class CarCatalogContentSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :car_catalog
end
