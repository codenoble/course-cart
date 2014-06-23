ActionMailer::Base.smtp_settings = {
  :address => Settings.email.smtp.server
}