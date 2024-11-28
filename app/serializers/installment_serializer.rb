class InstallmentSerializer < ActiveModel::Serializer
  attributes :id, :car_id, :name, :phone, :credit_term, :initial_contribution
end
