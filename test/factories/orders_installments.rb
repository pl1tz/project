FactoryBot.define do
  factory :orders_installment do
    installment { nil }
    order_status { nil }
    description { "MyString" }
  end
end
