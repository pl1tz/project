class ExtraSerializer < ActiveModel::Serializer
  attributes :id, :car_id, :category_id, :extra_name_id
  has_one :car
  has_one :category
  has_one :extra_name
end
