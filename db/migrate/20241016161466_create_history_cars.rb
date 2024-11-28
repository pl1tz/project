class CreateHistoryCars < ActiveRecord::Migration[7.2]
  def change
    create_table :history_cars do |t|
      t.references :car, null: false, foreign_key: true
      t.string :vin
      t.string :registration_number
      t.integer :last_mileage
      t.string :registration_restrictions
      t.string :registration_restrictions_info
      t.string :wanted_status
      t.string :wanted_status_info
      t.string :pledge_status
      t.string :pledge_status_info
      t.integer :previous_owners
      t.string :accidents_found
      t.string :accidents_found_info
      t.string :repair_estimates_found
      t.string :repair_estimates_found_info
      t.string :carsharing_usage
      t.string :carsharing_usage_info
      t.string :taxi_usage
      t.string :taxi_usage_info
      t.string :diagnostics_found
      t.string :diagnostics_found_info
      t.string :technical_inspection_found
      t.string :technical_inspection_found_info
      t.string :imported
      t.string :imported_info
      t.string :insurance_found
      t.string :insurance_found_info
      t.string :recall_campaigns_found
      t.string :recall_campaigns_found_info
      t.timestamps
    end
  end
end
