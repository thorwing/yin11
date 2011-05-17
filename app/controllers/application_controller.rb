class ApplicationController < ActionController::Base

  helper_method :current_user , :has_permission?

  def has_permission?(permission)
    has_permission = false
    if current_user
      case permission
        when :user
          has_permission = true
        when :editor
          has_permission = current_user.is_editor? || current_user.is_admin?
        when :admin
          has_permission = current_user.is_admin?
      end
    end
    has_permission
  end

  def current_user
      @current_user ||= (login_from_session || login_from_cookie) unless @current_user == false
  end

  # Store the given user id in the session.
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
  end

  # Called from #current_user. First attempt to login by the user id stored in the session
  def login_from_session
    User.find(session[:user_id]) if session[:user_id]
  end

  # Called from #current_user. Finaly, attempt to login by an expiring token in the cookie.  # for the paranoid: we _should_ be storing user_token = hash(cookie_token, request IP)
  def login_from_cookie
    user = cookies[:auth_token] && User.find(:first, :conditions => {:remember_token => cookies[:auth_token]})
    if user && user.remember_token?
      self.current_user = user
      handle_remember_cookie! false # freshen cookie token (keeping date)
      self.current_user
    end
  end

  # This is ususally what you want; resetting the session willy-nilly wreaks
  # havoc with forgery protection, and is only strictly necessary on login.
  # However, **all session state variables should be unset here**.
  def logout_keeping_session!
    # Kill server-side auth cookie
    @current_user.forget_me if @current_user.is_a? User
    @current_user = false # not logged in, and don't do it for me
    kill_remember_cookie! # Kill client-side auth cookie
    session[:user_id] = nil # keeps the session but kill our variable

    # explicitly kill any other session variables you set
  end

  # The session should only be reset at the tail end of a form POST --
  # otherwise the request forgery protection fails. It's only really necessary
  # when you cross quarantine (logged-out to logged-in).
  def logout_killing_session!
    logout_keeping_session!
    reset_session
  end

  #
  ## Remember_me Tokens
  #
  # Cookies shouldn't be allowed to persist past their freshness date,
  # and they should be changed at each login
  # Cookies shouldn't be allowed to persist past their freshness date,
  # and they should be changed at each login

  def valid_remember_cookie?
    return nil unless @current_user
    (@current_user.remember_token?) &&
        (cookies[:auth_token] == @current_user.remember_token)
  end

  # Refresh the cookie auth token if it exists, create it otherwise
  def handle_remember_cookie!(new_cookie_flag)
    return unless @current_user
    case
      when valid_remember_cookie? then @current_user.refresh_token # keeping same expiry date
      when new_cookie_flag then @current_user.remember_me
      else @current_user.forget_me
    end
    send_remember_cookie!
  end

  def kill_remember_cookie!
    cookies.delete :auth_token
  end

  def send_remember_cookie!
    cookies[:auth_token] = {
        :value => @current_user.remember_token,
        :expires => @current_user.remember_token_expires_at }
  end



  protected
  #TODO
  def require_permission(permission)
    if has_permission?(permission)
      true
    else
      redirect_to :log_in, :notice => "You need #{permission} permission"
      false
    end
  end

  def the_author_himself(class_name, object_id, or_admin = false)
    has_permission = false
    has_permission = true if or_admin && current_user.is_admin?
    unless has_permission
      class_name.capitalize!
      object = eval "#{class_name}.find(\"#{object_id}\")"
      #TODO
      has_permission = (object.author_id == current_user.id)
    end

    if has_permission
      true
    else
      redirect_to :root, :notice => t("reviews.only_author_self_notice")
      false
    end
  end

  def get_vote_weight_of_current_user
    weight = 0

    if current_user
      if current_user.is_admin?
        weight = 5
      elsif current_user.is_editor?
        weight = 3
      else
        weight = 1
      end
    end
    weight
  end
end
