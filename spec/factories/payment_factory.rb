FactoryGirl.define do
  factory :payment do
    trait :successful do
      status :success
    end
  end
end
