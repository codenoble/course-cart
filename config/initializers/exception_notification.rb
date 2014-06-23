if defined? ::ExceptionNotifier
  CourseCart::Application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix: '[course-cart] ',
      sender_address: Settings.email.from,
      exception_recipients: Settings.exceptions.mail_to
    }
end