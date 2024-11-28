class EngineTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :engine_power, :engine_capacity
end
