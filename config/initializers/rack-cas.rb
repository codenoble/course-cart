# Rack::CAS includes a railtie by default but we're loading it manually here
# because of initializer order issues with rails_config.

if Rails.env.test?
  require 'rack/fake_cas'

  # These are here so we can use RackCAS::Server#login_url in testing
  require 'rack-cas/configuration'
  require 'rack-cas/server'
  RackCAS.configure { |c| c.server_url = 'http://example.com' }

  # We use swap because FakeCAS is included in the middleware by a the RackCAS railtie by default
  users = {
    'strongbad@example.com' => {
      'eduPersonNickname' => 'Strong',
      'sn' => 'Bad',
      'mail' => 'dangeresque@example.com'
    }
  }
  CourseCart::Application.config.middleware.swap Rack::FakeCAS, Rack::FakeCAS, {}, users
else
  require 'rack/cas'
  require 'rack-cas/session_store/mongoid'

  extra_attributes = [:cn, :employeeId, :eduPersonNickname, :sn, :mail, :url, :eduPersonAffiliation, :eduPersonEntitlement]
  CourseCart::Application.config.middleware.use Rack::CAS,
    server_url: Settings.cas.url,
    session_store: RackCAS::MongoidStore,
    extra_attributes_filter: extra_attributes
end
