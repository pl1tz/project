class HistoryCarDetailSerializer < ActiveModel::Serializer
    attributes :id, :vin, :last_mileage, :previous_owners  
  
    belongs_to :car
  end
  