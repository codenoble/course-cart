module SessionHelper
  def create_account_url
    uri = URI.parse(Settings.accounts.create_url)
    uri.query = "return=#{CGI.escape(request.url)}"
    uri.to_s
  end

  def login_url
    RackCAS::Server.new(RackCAS.config.server_url).login_url(request.url).to_s
  end
end
