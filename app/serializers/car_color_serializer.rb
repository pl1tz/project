class CarColorSerializer < ActiveModel::Serializer
  attributes :id, :background, :name, :image
  has_one :carcatalog
end