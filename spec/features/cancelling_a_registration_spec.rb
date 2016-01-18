require 'spec_helper'
include SessionHelper

describe 'cancel a registration' do
  let(:user) { create :user }
  let(:offering) { create :offering, :default, passed_amount_validation_key: 'cDWsPWumq3dpEli93tAGetbjN2LQE7K' }
  let!(:product) { create :product, offering: offering, price: 42 }
  let(:uuid) { '778bbc86-b1ac-4ebc-8ce9-8a073eb034a0' }
  let(:user) { User.first }
  let(:order) { Order.first }

  context 'with a required question' do
    let!(:question) { create :question, offering: offering, type: :check_box, name: 'Do you have to jump?', required: true }

    before { expect(Payment).to receive(:generate_uuid).and_return uuid }

    context 'when already logged in' do
      before { login_as 'strongbad@example.com' }

      it 'cancels the order' do
        visit root_path

        expect(page).to_not have_content 'Login'

        expect(page).to have_content 'Registration'
        expect(page).to have_content 'Thank you for your interest'
        check product.name
        click_button 'Continue'

        expect(page).to have_content 'Please complete the following questions to continue your registration'
        check question.name
        click_button 'Continue'

        expect(page).to have_content 'Please confirm your registration below'
        expect(page).to have_content product.name
        expect(page).to have_button 'Finalize Registration'

        expect(Order.count).to be 1
        expect(order.reload.cancelled?).to be false
        click_link 'Back'

        expect(page).to have_content 'Please complete the following questions to continue your registration'
        expect(Order.count).to be 1
        expect(order.reload.cancelled?).to be false
        click_button 'Back'

        expect(page).to have_content 'Thank you for your interest'
        expect(Order.count).to be 1
        expect(order.reload.cancelled?).to be true
      end
    end
  end
end
