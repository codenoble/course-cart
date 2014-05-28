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
    let(:offering_attrs) { {order_validators: {'GrumpyCatValidator' => nil}} }
    its('errors.full_messages') { should eql ['NO!'] }
  end

  context 'with passing Offering#order_validators' do
    let(:offering_attrs) { {order_validators: {'YesManValidator' => nil}} }
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
      let(:order) { build :order }
      let(:product) { create :product, available: 1 }
      let!(:other_purchase) { create :purchase, product: product }
      let!(:other_payment) { create :payment, :successful, order: other_purchase.order }

      before do
        order.purchases << build(:purchase, product: product)
        order.payment = build(:payment, :successful)
      end

      it { should be_invalid }
    end
  end
end