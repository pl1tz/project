class CarCatalogEngineSerializer < ActiveModel::Serializer
  attributes :id, :name_engines, :torque, :power, :cylinders, :engine_volume, :fuel_type, :engine_type
end
