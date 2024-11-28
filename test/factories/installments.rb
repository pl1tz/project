FactoryBot.define do
  factory :installment do
    car_id { 1 }
    customer_car { "MyText" }
    name { "MyString" }
    phone { "MyString" }
    credit_term { 1 }
    initial_contribution { "9.99" }
  end
end
