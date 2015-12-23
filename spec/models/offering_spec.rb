require 'spec_helper'

describe Offering, type: :model do
  it { expect(Offering).to embed_many :questions }
  it { expect(Offering).to have_many :orders }
  it { expect(Offering).to have_many :products }
  it { expect(Offering).to have_field :name }
  it { expect(Offering).to have_field :period }
  it { expect(Offering).to have_field :layout }
  it { expect(Offering).to have_field :preflight_checks }
  it { expect(Offering).to have_field :order_validators }
  it { expect(Offering).to have_field :order_warners }
  it { expect(Offering).to have_field :default }
  it { expect(Offering).to have_field :upay_store_id }
  it { expect(Offering).to have_field :context }
  it { expect(Offering).to have_field :passed_amount_validation_key }
  it { expect(Offering).to have_field :posting_key }

  it { expect(Offering).to validate_presence_of :name }
  it { expect(Offering).to validate_uniqueness_of :name }
  it { expect(Offering).to validate_presence_of :upay_store_id }
  it { expect(Offering).to validate_presence_of :context }
  it { expect(Offering).to validate_presence_of :passed_amount_validation_key }
  it { expect(Offering).to validate_presence_of :posting_key }

  it { expect(Offering.new).to respond_to :slug }
  it { expect(Offering.new).to respond_to :to_s }

  describe 'scopes' do
    describe 'open' do
      before { create :offering, period: period }
      subject { Offering.open }

      context 'when period is nil' do
        let(:period) { nil }
        it { expect(subject.length).to eql 1 }
      end

      context 'when period start is past and end is upcoming' do
        let(:period) { 1.day.ago..1.day.from_now }
        it { expect(subject.length).to eql 1 }
      end

      context 'when period start is upcoming' do
        let(:period) { 1.day.from_now..2.days.from_now }
        it { expect(subject.length).to eql 0 }
      end

      context 'when period end is past' do
        let(:period) { 2.day.ago..1.days.ago }
        it { expect(subject.length).to eql 0 }
      end
    end
  end

  describe '#open?' do
    subject { build :offering, period: period }

    context 'when period is nil' do
      let(:period) { nil }
      it { expect(subject.open?).to be true }
    end

    context 'when period start is past and end is upcoming' do
      let(:period) { 1.day.ago..1.day.from_now }
      it { expect(subject.open?).to be true }
    end

    context 'when period start is upcoming' do
      let(:period) { 1.day.from_now..2.days.from_now }
      it { expect(subject.open?).to be false }
    end

    context 'when period end is past' do
      let(:period) { 2.day.ago..1.days.ago }
      it { expect(subject.open?).to be false }
    end
  end

  context 'after_save' do
    subject { create :offering }

    it 'generates keys automatically' do
      expect(subject.posting_key).to match(/[a-zA-Z0-9]{30}/)
      expect(subject.passed_amount_validation_key).to match(/[a-zA-Z0-9]{30}/)
    end
  end
end
