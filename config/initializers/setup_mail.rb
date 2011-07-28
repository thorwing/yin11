require "development_mail_interceptor.rb"

ActionMailer::Base.smtp_settings = {
  :address			=> "smtp.gmail.com",
  :port			=> 587,
  :user_name		=> "staff@yin11.com",
  #:domain => "yin11.com",
  :password		=> "Iam1staff",
  :authentication		=> "plain",
  :enable_starttls_auto => true
  }


ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?