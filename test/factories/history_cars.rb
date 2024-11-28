FactoryBot.define do
  factory :history_car do
    car { nil }
    vin { "MyString" }
    registration_number { "MyString" }
    last_mileage { 1 }
    registration_restrictions { false }
    wanted_status { false }
    pledge_status { false }
    previous_owners { 1 }
    accidents_found { false }
    repair_estimates_found { false }
    taxi_usage { false }
    carsharing_usage { false }
    diagnostics_found { false }
    technical_inspection_found { false }
    imported { false }
    insurance_found { false }
    recall_campaigns_found { false }
  end
end
