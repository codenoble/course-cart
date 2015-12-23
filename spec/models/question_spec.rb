require 'spec_helper'

describe Question, type: :model do
  it { expect(Question).to be_embedded_in :offering }
  it { expect(Question).to have_field :name }
  it { expect(Question).to have_field :type }
  it { expect(Question).to have_field :options }
  it { expect(Question).to have_field :required }

  it { expect(Question).to validate_presence_of :name }
  it { expect(Question).to validate_presence_of :type }
  it { expect(Question).to validate_inclusion_of(:type).to_allow([:text_field, :text_area]) }

  describe 'validates' do
    subject { build :question, type: type, options: options}
    context 'when type is select' do
      let(:type) { :select }

      context 'with options' do
        let(:options) { ['Red', 'Blue', 'Yellow, no wait...'] }
        it { expect(subject).to be_valid }
      end

      context 'without options' do
        let(:options) { [] }
        it { expect(subject).to be_invalid }
      end
    end

    context 'when type is not select' do
      let(:type) { :text_field }

      context 'with options' do
        let(:options) { ['Red', 'Blue', 'Yellow, no wait...'] }
        it { expect(subject).to be_invalid }
      end

      context 'without options' do
        let(:options) { [] }
        it { expect(subject).to be_valid }
      end
    end
  end

  describe '#slug' do
    subject { build :question, name: 'What is your quest?' }
    it { expect(subject.slug).to eql 'what_is_your_quest' }
  end
end
