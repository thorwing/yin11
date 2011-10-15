class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :application, :layout, :validator, :external_link, :images
  include ApplicationHelper
  before_filter :set_locale, :set_city
  helper_method :current_user, :current_city, :the_author_himself

  def current_user
    @current_user ||= User.of_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  def current_city
    @current_city ||= City.find(cookies[:current_city]) if cookies[:current_city]
  end

  def current_city=(new_city)
    @current_city = new_city
    cookies.permanent[:current_city] = new_city.id
  end

  protected
  def set_locale
    I18n.locale = "zh-CN"
  end

  def set_city
    #should be set only once
    unless cookies[:current_city]
      #TODO
      city = City.of_eng_name(request.location.city.upcase) if request.location.present?
      #TODO
      city ||= City.find(DEFAULT_CITY_CODE)
      cookies.permanent[:current_city] = city.id if city
    end
  end

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
      if (or_admin and current_user.has_permission?(:admin))
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

  #def self.get_tiny_mce_style
  #   {
  #     :theme => 'advanced',
  #     :theme_advanced_toolbar_location => "top",
  #     :theme_advanced_toolbar_align => "left",
  #     :theme_advanced_resizing => true,
  #     :theme_advanced_resize_horizontal => false,
  #     :theme_advanced_buttons1 => %w{ formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent separator bullist numlist forecolor backcolor separator link unlink image undo redo},
  #     :theme_advanced_buttons2 => [],
  #     :theme_advanced_buttons3 => []
  #   }
  # end

  #def self.rescue_errors
  #  rescue_from Exception,                            :with => :render_error
  #  rescue_from RuntimeError,                         :with => :render_error
  #  rescue_from Mongoid::Errors::DocumentNotFound,    :with => :render_not_found
  #  rescue_from ActionController::RoutingError,       :with => :render_not_found
  #  rescue_from ActionController::UnknownController,  :with => :render_not_found
  #  rescue_from ActionController::UnknownAction,      :with => :render_not_found
  #end
  ##TODO
  #rescue_errors unless Rails.env.development?
  #
  #def render_not_found(exception = nil)
  #   render :template => "errors/404", :status => 404 #, :layout => 'public'
  #end
  #
  #def render_error(exception = nil)
  #  render :template => "errors/500", :status => 500 #, :layout => 'public'
  #end

end
