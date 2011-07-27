class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => I18n.t("mailers.reset_password_subject")
  end

  def welcome(user)
    @user = user
    mail :to => user.email, :subject => I18n.t("mailers.welcome_subject")
  end
end
