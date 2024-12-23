class CarCatalogEngineSerializer < ActiveModel::Serializer
  attributes :id, :name_engines, :torque, :power, :cylinders, :engine_volume, :fuel_type, :engine_type
  has_one :car_catalog
end
