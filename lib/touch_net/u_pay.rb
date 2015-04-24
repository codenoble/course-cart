require 'digest/md5'
require 'base64'

module TouchNet
  class UPay
    PRODUCTION_SERVER = 'https://secure.touchnet.com'
    STAGING_SERVER = 'https://secure.touchnet.com:8443'
    COUNTRY = 'US'

    attr_accessor :site_id

    def initialize(site_id, context, passed_amount_validation_key = nil, production = true)
      @site_id = site_id
      @context = context
      @passed_amount_validation_key = passed_amount_validation_key
      @production = production
    end

    def url
      "#{@production ? PRODUCTION_SERVER : STAGING_SERVER}/#{@context}/web/index.jsp"
    end

    def parameters_for(order, additional_params = {})
      raise ArgumentError, 'Payment record not found' unless order.payment?

      user = order.user

      params = {}.tap do |p|
        p[:UPAY_SITE_ID]        = site_id
        p[:BILL_NAME]           = user.name
        p[:BILL_EMAIL_ADDRESS]  = user.email
        p[:EXT_TRANS_ID]        = order.payment.uuid
        p[:AMT]                 = formatted_amount(order.total)
        p[:VALIDATION_KEY]      = generate_validation_key(order)
      end

      additional_params.each do |name, value|
        params[name.upcase] = value unless value.nil?
      end

      params
    end

    def generate_validation_key(order)
      key = "#{passed_amount_validation_key}#{order.payment.uuid}#{formatted_amount(order.total)}"
      md5 = Digest::MD5.hexdigest key
      ascii_md5 = md5.scan(/../).collect {|x| x.to_i(16).chr }.join
      Base64.encode64 ascii_md5.strip
    end

    def formatted_amount(amount)
      "%.2f" % amount.to_i
    end

    private

    attr_reader :passed_amount_validation_key
  end
end
