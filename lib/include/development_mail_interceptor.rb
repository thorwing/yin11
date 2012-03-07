class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    #TODO
    message.to = "admin@chixinbugai.com"
  end
end
