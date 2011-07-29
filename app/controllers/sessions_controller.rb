class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.first(:conditions => {:email => params[:email], :enabled => true } )
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end

      msg = (user.role == INACTIVE_USER_ROLE) ? t("notices.activation_required") : t("notices.welcome_back", :name => user.login_name)
      redirect_back root_url, :notice => msg
    else
      flash.now.alert = t("authentication.invalid_usr_pwd")
      render "new"
    end
  end

  def destroy
    cookies.delete :auth_token
    redirect_to root_url, :notice => t("authentication.logged_out")
  end

end
