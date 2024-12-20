FactoryBot.define do
  factory :car_catalog_engine do
    car_catalog { nil }
    torque { 1 }
    power { 1 }
    cylinders { 1 }
    engine_volume { 1.5 }
    fuel_type { "MyString" }
    engine_type { "MyString" }
  end
end
