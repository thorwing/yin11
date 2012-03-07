require "development_mail_interceptor.rb"

ActionMailer::Base.smtp_settings = {
  :address			=> "127.0.0.1",
  :port			=> 25,
  #:user_name		=> "yinkuaizi@gmail.com",
  #:domain => "chixinbugai.com",
  #:password		=> "Yin11rocks",
  #:authentication		=> "plain",
  #:enable_starttls_auto => true
}


ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?