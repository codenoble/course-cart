FactoryGirl.define do
  factory :offering do
    name { Faker::Commerce.department }
  end
end
