FactoryGirl.define do
  factory :order do
    offering
    user

    trait :with_purchase do
      ignore { purchase_count 1 }

      after(:build) do |order, evaluator|
        create_list :purchase, evaluator.purchase_count, order: order, product: create(:product, offering: order.offering)
      end
    end
  end
end