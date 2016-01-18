FactoryGirl.define do
  factory :offering do
    name { Faker::Commerce.department }
    upay_store_id { rand(1..1000) }
    context { Faker::Internet.domain_name }

    trait :default do
      default true
    end
  end
end
