FactoryGirl.define do
  factory :offering do
    name { Faker::Commerce.department }
    upay_store_id { rand(1..1000) }
    context { Faker::Internet.domain_name }
  end
end
