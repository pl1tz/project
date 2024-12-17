FactoryBot.define do
  factory :car_catalog do
    brand { "MyString" }
    model { "MyString" }
    power { 1 }
    acceleration { 1.5 }
    consumption { 1.5 }
    max_speed { 1 }
  end
end
