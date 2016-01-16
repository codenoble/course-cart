FactoryGirl.define do
  factory :offering do
    sequence(:name) { |n| "Faker::Commerce.department #{n}" }
  end
end
