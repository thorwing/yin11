class UserMailer < ActionMailer::Base
  default :from => "staff@chixinbugai.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    email_with_name = "#{@user.login_name} <#{@user.email}>"
    mail :to => email_with_name, :subject => I18n.t("mailers.reset_password_subject")
  end

  #def email_verify(user)
  #  @user = user
  #  mail :to => user.email, :subject => I18n.t("mailers.verify_email_subject")
  #end

  #def updates(user, items)
  #  @user = user
  #  @items = items
  #  mail :to => user.email, :subject => I18n.t("mailers.updates_subject")
  #end
end
