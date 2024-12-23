class CarCatalogTexnoSerializer < ActiveModel::Serializer
  attributes :id, :image, :width, :height, :length
  has_one :car_catalog
end
