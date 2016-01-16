FactoryGirl.define do
  factory :product do
    sequence(:name) { |n| "Faker::Commerce.product_name#{n}" }
    price { Faker::Commerce.price }
  end
end
