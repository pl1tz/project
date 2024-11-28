class ModelSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand_id, :created_at, :updated_at
end

