class CarCatalogSerializer < ActiveModel::Serializer
  attributes :id, :brand, :model, :power, :acceleration, :consumption, :max_speed

  has_many :car_colors
end
