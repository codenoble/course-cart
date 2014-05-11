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

  describe '#valid?' do
    context 'with order incomplete and cancelled_at set' do
      let(:order) { build :order, :with_purchase, cancelled_at: Time.now }
      it { should be_valid }
    end

    context 'with order complete and cancelled_at set' do
      let(:payment) { build(:payment, :successful) }
      let(:order) { build :order, :with_purchase, cancelled_at: Time.now, payment: payment }
      it { should be_invalid }
    end

    context 'when at or over availability' do
      let(:product) { create :product, available: 1 }
      let!(:purchase) { build :purchase, product: product }
      before { create :purchase, product: product }
      subject { purchase.order }

      it { should be_invalid}
    end
  end
end