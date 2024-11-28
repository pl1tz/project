class ProgramSerializer < ActiveModel::Serializer
  attributes :id, :bank_id, :program_name, :interest_rate
  belongs_to :bank
end
