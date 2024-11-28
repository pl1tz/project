FactoryBot.define do
  factory :credit do
    car_id { 1 }
    name { "MyString" }
    phone { "MyString" }
    credit_term { 1 }
    initial_contribution { "9.99" }
    banks_id { 1 }
    programs_id { 1 }
  end
end
