FactoryBot.define do
  factory :orders_call_request do
    call_request { nil }
    order_status { nil }
    description { "MyString" }
  end
end
