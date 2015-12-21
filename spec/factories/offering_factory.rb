FactoryGirl.define do
  factory :offering do
    name { Faker::Commerce.department }
    upay_store_id { rand(1..1000) }
    context { Faker::Internet.domain_name }
    passed_amount_validation_key { Faker::Number.hexadecimal(30) }
    posting_key { Faker::Number.hexadecimal(30) }
  end
end
