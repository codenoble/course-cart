FactoryGirl.define do
  factory :offering do
    sequence(:name) { |n| "#{Faker::Commerce.department} #{n}" }
    upay_store_id { rand(1..1000) }
    context { Faker::Internet.domain_name }

    trait :default do
      default true
    end
  end
end
