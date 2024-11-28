FactoryBot.define do
  factory :car do
    model { nil }
    brand { nil }
    year { 1 }
    price { "9.99" }
    description { "MyText" }
    color { nil }
    body_type { nil }
    engine_type { nil }
    gearbox_type { nil }
    drive_type { nil }
    fuel_type { nil }
  end
end
