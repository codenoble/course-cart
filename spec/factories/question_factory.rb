FactoryGirl.define do
  factory :question do
    offering
    name { Faker::Lorem.word }
    type { :text_field }
  end
end
