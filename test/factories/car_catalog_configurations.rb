FactoryBot.define do
  factory :car_catalog_configuration do
    car_catalog { nil }
    package_group { "MyString" }
    package_name { "MyString" }
    volume { 1.5 }
    transmission { "MyString" }
    power { 1 }
    price { 1 }
    credit_discount { 1 }
    trade_in_discount { 1 }
    recycling_discount { 1 }
    special_price { 1 }
  end
end
