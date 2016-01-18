require 'spec_helper'
include SessionHelper

describe 'register for a course' do
  let(:user) { create :user }
  let(:offering) { create :offering, :default, passed_amount_validation_key: 'cDWsPWumq3dpEli93tAGetbjN2LQE7K' }
  let!(:product) { create :product, offering: offering, price: 42 }
  let(:uuid) { '778bbc86-b1ac-4ebc-8ce9-8a073eb034a0' }
  let(:user) { User.first }
  let(:order) { Order.first }

  context 'without questions' do
    before { expect(Payment).to receive(:generate_uuid).and_return uuid }

    context 'when already logged in' do
      before { login_as 'strongbad@example.com' }

      it 'lets your register' do
        visit root_path

        expect(page).to_not have_content 'Login'

        expect(page).to have_content 'Registration'
        expect(page).to have_content 'Thank you for your interest'
        check product.name
        click_button 'Continue'

        expect(page).to have_content 'Please confirm your registration below'
        expect(page).to have_content product.name
        expect(page).to have_button 'Finalize Registration'

        expect(page).to have_css %{#upay_form[action="https://test.secure.touchnet.net:8443/#{offering.context}/web/index.jsp"]}
        expect(page).to have_css %{#upay_form input[type=hidden][name=UPAY_SITE_ID][value="#{offering.upay_store_id}"]}
        expect(page).to have_css %{#upay_form input[type=hidden][name=BILL_NAME][value="#{user.name}"]}
        expect(page).to have_css %{#upay_form input[type=hidden][name=BILL_EMAIL_ADDRESS][value="#{user.email}"]}
        expect(page).to have_css %{#upay_form input[type=hidden][name=EXT_TRANS_ID][value="#{order.payment.uuid}"]}
        expect(page).to have_css %{#upay_form input[type=hidden][name=AMT][value="42.00"]}
        expect(page).to have_css %{#upay_form input[type=hidden][name=VALIDATION_KEY][value="HhydBu5Z66i8SN5pXN8nJg==\n"]}
        expect(page).to have_css %{#upay_form input[type=hidden][name=SUCCESS_LINK][value="http://www.example.com/orders/#{order.id}"]}
        expect(page).to have_css %{#upay_form input[type=hidden][name=CANCEL_LINK][value="http://www.example.com/orders/#{order.id}?cancelled=true"]}

        # POST /payment EXT_TRANS_ID, pmt_status, tgp_trans_id, sys_tracking_id, pmt_amt, posting_key
        page.driver.post '/payment',
          pmt_status: 'success',
          EXT_TRANS_ID: order.payment.uuid,
          tpg_trans_id: SecureRandom.hex,
          sys_tracking_id: SecureRandom.random_number(1_000_000_000),
          pmt_amount: 42.00,
          posting_key: offering.posting_key
        expect(page.driver.status_code).to eql 200

        visit order_path(order)
        expect(page).to have_content 'Your order was completed'
        expect(page).to have_content 'Name:Strong Bad'
        expect(page).to have_content 'Email:dangeresque@example.com'
        expect(page).to have_content product.name
        expect(page).to have_content '$42.00'
        expect(page).to_not have_content 'Finalize Registration'
      end
    end

    context 'when not logged in' do
      it 'requires you to login or create an account' do
        visit root_path

        expect(page).to have_content 'Login'

        expect(page).to have_content 'Registration'
        expect(page).to have_content 'Thank you for your interest'
        check product.name
        click_button 'Continue'

        expect(page).to have_content 'Please confirm your registration below'
        expect(page).to have_content product.name
        expect(page).to have_link 'Create Account'
        expect(page).to have_link 'Login'
        expect(page).to_not have_button 'Finalize Registration'
        login_as 'strongbad@example.com'

        expect(page).to have_content 'Please confirm your registration below'
        expect(page).to have_content product.name
        expect(page).to_not have_link 'Login'
        expect(page).to_not have_link 'Create Account'
        expect(page).to have_button 'Finalize Registration'
      end
    end
  end

  context 'with required questions' do
    let!(:question_a) { create :question, offering: offering, type: :check_box, name: 'Do you have to jump?', required: true }
    let!(:question_b) { create :question, offering: offering, type: :text_field, name: 'Who is your stunt double?', required: false }

    it 'requires answers' do
      visit root_path

      login_as 'strongbad@example.com'
      expect(page).to_not have_content 'Login'

      expect(page).to have_content 'Registration'
      expect(page).to have_content 'Thank you for your interest'
      check product.name
      click_button 'Continue'

      expect(page).to have_content 'Please complete the following questions to continue your registration'
      fill_in question_b.name, with: 'Only big wusses and lesser wimps use stunt doubles'
      click_button 'Continue'

      expect(page).to have_content 'Answers is invalid'
      expect(page).to have_css 'input[type=text][value="Only big wusses and lesser wimps use stunt doubles"]'
      check question_a.name
      click_button 'Continue'

      expect(page).to_not have_content 'complete the following questions'
      expect(page).to have_content 'Please confirm your registration below'
      expect(page).to have_content product.name
      expect(page).to have_content "#{question_a.name}Yes"
      expect(page).to have_button 'Finalize Registration'
    end
  end

  context 'with optional questions' do
    let!(:question) { create :question, offering: offering, type: :check_box, name: 'Do you have to jump?', required: false }

    it 'requires answers' do
      visit root_path

      login_as 'strongbad@example.com'
      expect(page).to_not have_content 'Login'

      expect(page).to have_content 'Registration'
      expect(page).to have_content 'Thank you for your interest'
      check product.name
      click_button 'Continue'

      expect(page).to have_content 'Please complete the following questions to continue your registration'
      click_button 'Continue'

      expect(page).to_not have_content 'Answers is invalid'
      expect(page).to have_content "#{question.name}No"

      expect(page).to_not have_content 'complete the following questions'
      expect(page).to have_content 'Please confirm your registration below'
      expect(page).to have_content product.name
      expect(page).to have_button 'Finalize Registration'
    end
  end
end
