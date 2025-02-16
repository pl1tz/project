class CarCatalogSerializer < ActiveModel::Serializer
  attributes :id, :brand, :model, :power, :acceleration, :consumption, :max_speed, :visibility

  has_many :car_colors
  has_many :car_catalog_contents
  has_many :car_catalog_texnos
  has_many :car_catalog_engines
  has_many :car_catalog_images
  has_many :car_catalog_configurations
end
