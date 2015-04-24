FactoryGirl.define do
  factory :purchase do
    order { build :order }
    product
  end
end
