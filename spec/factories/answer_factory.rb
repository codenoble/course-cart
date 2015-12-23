FactoryGirl.define do
  factory :answer do
    order { create :order, :with_purchase }
    question_id { create :question, order: order }
    value { Faker::Lorem.word }
  end
end
