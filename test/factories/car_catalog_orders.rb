FactoryBot.define do
  factory :car_catalog_order do
    order_status { nil }
    car_catalog { "" }
    name { "MyString" }
    phone { "MyString" }
  end
end
