require "development_mail_interceptor.rb"

ActionMailer::Base.smtp_settings = {
  :address			=> "smtp.gmail.com",
  :port			=> 587,
  :user_name		=> "yin11.mailer@gmail.com",
  #:domain => "yin11.com",
  :password		=> "Yin11great!",
  :authentication		=> "plain",
  :enable_starttls_auto => true
  }


ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?