FactoryBot.define do
  factory :credit_program do
    bank_id { 1 }
    program_name { "MyString" }
    interest_rate { "9.99" }
    max_term { 1 }
    max_amount { "9.99" }
    created_at { "2024-10-21 12:49:12" }
  end
end
