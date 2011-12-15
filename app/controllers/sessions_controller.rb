class SessionsController < ApplicationController
  #TODO
  # Self-signed key will generate warnings
  #force_ssl unless Rails.env.test?

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

      redirect_back '/me'
    else
      flash.now.alert = t("authentication.invalid_usr_pwd")
      render "new"
    end
  end

  def destroy
    cookies.delete :auth_token
    redirect_to root_url
  end

end
