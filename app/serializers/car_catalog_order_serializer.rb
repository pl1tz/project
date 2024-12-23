class CarCatalogOrderSerializer < ActiveModel::Serializer
  attributes :id, :car_catalog, :name, :phone
  has_one :order_status
end
