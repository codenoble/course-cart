require 'spec_helper'

describe Product do
  let(:attrs) { {} }
  let(:product) { build :product, attrs }
  subject { product }

  describe '#sold_out?' do
    before { product.save! }

    context 'when #available is nil' do
      let(:attrs) { {available: nil} }

      it { expect(subject.sold_out?).to be false }
    end

    context 'with less than #available orders' do
      let(:attrs) { {available: 2} }
      before { create :purchase, product: product }

      it { expect(subject.sold_out?).to be false }
    end

    context 'with same as #available orders' do
      let(:attrs) { {available: 1} }
      let!(:purchase) { create :purchase, product: product }
      let!(:payment) { create :payment, :successful, order: purchase.order }

      it { expect(subject.sold_out?).to be true }
    end
  end
end
