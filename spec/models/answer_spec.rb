require 'spec_helper'

describe Answer, type: :model do
  it { expect(Answer).to be_embedded_in :order }
  it { expect(Answer).to have_field :question_id }
  it { expect(Answer).to have_field :value }

  it { expect(subject).to respond_to :offering }
  it { expect(subject).to respond_to :name }
  it { expect(subject).to respond_to :type }
  it { expect(subject).to respond_to :required? }

  it { expect(Answer).to validate_presence_of :question_id }

  context 'when built with associations' do
    let(:type) { :text_area }
    let(:required) { false }
    let(:question_id) { question.id }
    let(:value) { 'whatever' }
    let(:offering) { create :offering }
    let(:order) { create :order, :with_purchase, offering: offering }
    let(:question) { create :question, offering: offering, type: type, required: required }
    subject { build :answer, order: order, question_id: question_id, value: value }

    describe 'validate' do
      context 'when question_id for a question in the offering' do
        it { expect(subject).to be_valid }
      end

      context 'when question_id for a question in the offering' do
        let(:question_id) { create(:question).id }
        it { expect(subject).to be_invalid }
      end

      context 'when required' do
        let(:required) { true }

        context 'when type is check_box' do
          let(:type) { :check_box }

          context 'when value is "No"' do
            let(:value) { 'No' }
            it { expect(subject).to be_invalid }
          end

          context 'when value is "Yes"' do
            let(:value) { 'Yes' }
            it { expect(subject).to be_valid }
          end
        end

        context 'when type is not check_box' do
          context 'when value is blank' do
            let(:value) { '' }
            it { expect(subject).to be_invalid }
          end

          context 'when value is present' do
            it { expect(subject).to be_valid }
          end
        end
      end
    end

    describe '#question' do
      it { expect(subject.question).to eql question }
    end
  end
end
