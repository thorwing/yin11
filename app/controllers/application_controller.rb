class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :application, :layout, :validator, :external_link, :images, :search
  include ApplicationHelper
  helper_method :current_user, :current_city, :the_author_himself

  def current_user
    @current_user ||= User.of_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  protected

  # redirect somewhere that will eventually return back to here
  def redirect_away(*params)
    session[:original_uri] = request.fullpath
    redirect_to(*params)
  end

  # returns the person to either the original url from a redirect_away or to a default url
  def redirect_back(*params)
    uri = session[:original_uri]
    session[:original_uri] = nil
    if uri
      redirect_to uri
    else
      redirect_to(*params)
    end
  end

  def require_permission(permission)
    if current_user && current_user.has_permission?(permission)
      true
    else
      if current_user
        redirect_away :root, :notice => t("notices.need_permission_not_logged", :permission => t("roles.#{permission.to_s}") )
      else
        redirect_away :login, :notice => t("notices.need_permission_logged", :permission => permission)
      end
      false
    end
  end

  def the_author_himself(class_name, object_id, or_admin = false, is_redirect = true)
    has_permission = false
    if current_user
      if (or_admin and current_user.has_permission?(:administrator))
        has_permission = true
      else
        object = eval "#{class_name.capitalize}.find(\"#{object_id}\")"
        if object.respond_to?(:author_id)
          has_permission = (object.author_id == current_user.id)
        else
          raise "The object of " + class_name + " doesn't implement author_id."
        end
      end
    end

    (redirect_to :root, :alert => t("alerts.only_author_self")) if (not has_permission and is_redirect)
    has_permission
  end

  def self.rescue_errors
    rescue_from Exception,                            :with => :render_error
    rescue_from RuntimeError,                         :with => :render_error
    rescue_from Mongoid::Errors::DocumentNotFound,    :with => :render_not_found
    rescue_from ActionController::RoutingError,       :with => :render_not_found
    rescue_from ActionController::UnknownController,  :with => :render_not_found
    rescue_from ActionController::UnknownAction,      :with => :render_not_found
  end
  #TODO
  rescue_errors unless (Rails.env.development? || Rails.env.test?)

  def render_not_found(exception = nil)
    Rails.logger.error exception.message if exception
    Rails.logger.error exception.backtrace if exception
    render :template => "errors/404", :status => 404 #, :layout => 'public'
  end

  def render_error(exception = nil)
    Rails.logger.error exception.message if exception
    Rails.logger.error exception.backtrace if exception
    render :template => "errors/500", :status => 500 #, :layout => 'public'
  end

end
