class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate!

  def update
    order = Order.find_by('payment.uuid' => params[:EXT_TRANS_ID])
    payment = order.payment

    authorize payment

    case params[:pmt_status]
    when 'success'
      payment.tpg_trans_id = params[:tpg_trans_id]
      payment.pmt_status = params[:pmt_status]
      payment.sys_tracking_id = params[:sys_tracking_id]
      payment.pmt_amt = params[:pmt_amt]
      payment.succeeded_at = DateTime.now
      payment.details = request.POST.try(:to_hash)
      payment.save!

    when 'cancelled'
      order.cancelled_at = Time.now
      order.payment.pmt_status = params[:pmt_status]
      order.save!
    end

    response = if order.errors.empty?
      'success'
    else
      "error: #{order.errors.full_messages.to_sentence}"
    end

    render text: response
  end

  private

  def pundit_user
    # No users here, just keys
    params[:posting_key]
  end
end
