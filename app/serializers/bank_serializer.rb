class BankSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :created_at
end
