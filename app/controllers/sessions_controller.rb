class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      self.current_user = user

      # Remember me functionality
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag

      notice = "Welcome, #{user.login_name}"
      redirect_to root_url, :notice => notice
    else
      flash.now.alert = t("authentication.invalid_usr_pwd")
      render "new"
    end
  end

  def destroy
    logout_killing_session!
    redirect_to root_url, :notice => t("authentication.logged_out")
  end

end
