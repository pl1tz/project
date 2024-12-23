FactoryBot.define do
  factory :car_catalog_order do
    car_catalog { nil }
    name { "MyString" }
    phone { "MyString" }
  end
end
