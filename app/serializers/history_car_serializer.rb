class HistoryCarSerializer < ActiveModel::Serializer
  attributes :id, :vin, :registration_number, :last_mileage, :previous_owners, 
  :registration_restrictions, :registration_restrictions_info, 
  :wanted_status, :wanted_status_info, 
  :pledge_status, :pledge_status_info, 
  :accidents_found, :accidents_found_info, 
  :repair_estimates_found, :repair_estimates_found_info,
  :carsharing_usage, :carsharing_usage_info,
  :taxi_usage, :taxi_usage_info, 
  :diagnostics_found, :diagnostics_found_info, 
  :technical_inspection_found, :technical_inspection_found_info, 
  :imported, :imported_info, 
  :insurance_found, :insurance_found_info, 
  :recall_campaigns_found, :recall_campaigns_found_info

  belongs_to :car
end
