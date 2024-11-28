class ContactSerializer < ActiveModel::Serializer
  attributes :id, :phone, :mode_operation, :auto_address
end
