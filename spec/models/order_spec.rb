require 'spec_helper'

describe Order do
  let(:offering_attrs) { {} }
  let(:offering) { create :offering, offering_attrs }
  let(:order) { build :order, :with_purchase, offering: offering }
  subject { order }

  context 'without Offering#order_validators' do
    it { should be_valid }
  end

  context 'with failing Offering#order_validators' do
    let(:offering_attrs) { {order_validators: ['GrumpyCatValidator']} }
    it { should be_invalid }
  end

  context 'with passing Offering#order_validators' do
    let(:offering_attrs) { {order_validators: ['YesManValidator']} }
    it { should be_valid }
  end
end