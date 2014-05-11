require 'spec_helper'

describe Product do
  let(:attrs) { {} }
  let(:product) { build :product, attrs }
  subject { product }

  describe '#sold_out?' do
    before { product.save! }

    context 'when #available is nil' do
      let(:attrs) { {available: nil} }

      its(:sold_out?) { should be_false }
    end

    context 'with less than #available orders' do
      let(:attrs) { {available: 2} }
      before { create :purchase, product: product }

      its(:sold_out?) { should be_false }
    end

    context 'with same as #available orders' do
      let(:attrs) { {available: 1} }
      before { create :purchase, product: product }

      its(:sold_out?) { should be_true }
    end
  end
end