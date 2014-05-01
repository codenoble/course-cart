class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate!

  def update
    render_error_page(403) and return unless posting_key_valid?

    order = Order.find_by('payment.uuid' => params[:EXT_TRANS_ID])
    payment = order.payment

    case params[:pmt_status]
    when 'success'
      payment.tpg_trans_id = params[:tpg_trans_id]
      payment.pmt_status = params[:pmt_status]
      payment.sys_tracking_id = params[:sys_tracking_id]
      payment.succeeded_at = DateTime.now
      # TODO: store all params
      payment.save!

    when 'cancelled'
      # TODO
    end

    render text: 'success'
  end

  private

  def posting_key_valid?
    params[:posting_key] == Settings.touch_net.posting_key
  end
end