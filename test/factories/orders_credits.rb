FactoryBot.define do
  factory :orders_credit do
    credit { nil }
    order_status { nil }
    description { "MyString" }
  end
end
