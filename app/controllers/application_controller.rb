class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :layout
  before_filter :set_locale, :set_city
  helper_method :current_user, :current_city
  helper_method :get_related_reviews_of, :get_related_articles_of, :the_author_himself, :get_region
  FOOD_ARTICLES_LIMIT = 5
  FOOD_REVIEWS_LIMIT = 5


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

  def set_city
    @current_city_name = request.location.city
    if session[:current_city].blank?
      @current_city = City.first(:conditions => {:name => @current_city_name})
      @current_city ||= City.first(:conditions => {:name => t("system.default_city")})
      session[:current_city] = @current_city.name if @current_city
    end
  end

  def current_city
    @current_city ||= City.first(:conditions => {:name => session[:current_city]})
  end

  def current_city=(new_city)
    @current_city = new_city
    session[:current_city] = @current_city.name
  end

  protected
  def set_locale
    I18n.locale = "zh-CN"
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

  #TODO
  def require_permission(permission)
    if current_user && current_user.has_permission?(permission)
      true
    else
      current_user ? (redirect_away :root, :notice => t("notices.need_permission_logged", :permission => permission)) : (redirect_away :log_in, :notice => t("notices.need_permission_not_logged", :permission => t("roles.normal_user") ))
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

    (redirect_to :root, :notice => t("reviews.only_author_self_notice")) if (not has_permission and is_redirect)
    has_permission
  end

  def get_vote_weight_of_current_user
    weight = 0

    if current_user
      if current_user.has_permission?(:admin)
        weight = 5
      elsif current_user.has_permission?(:editor)
        weight = 3
      else
        weight = 1
      end
    end
    weight
  end

  #TODO
  def get_related_reviews_of(food)

    result = Review.in_days_of(7).about(food).desc(:reported_on).limit(FOOD_REVIEWS_LIMIT)

    if result.size < FOOD_REVIEWS_LIMIT
      result = result | Review.in_days_of(14).about(food).desc(:reported_on)
    end

    result.size > FOOD_REVIEWS_LIMIT ? result[0...FOOD_REVIEWS_LIMIT - 1] : result
  end

  def get_related_articles_of(food, user = nil)
    result = []
    #result = Article.enabled.in_days_of(7).about(food).in_city(user.profile.address.city_id).desc(:created_at).limit(FOOD_ARTICLES_LIMIT) if user

    if result.size < FOOD_ARTICLES_LIMIT
      result = result | Article.enabled.in_days_of(14).about(food).desc(:reported_on)
    end

    result.size > FOOD_ARTICLES_LIMIT ? result[0...FOOD_ARTICLES_LIMIT - 1] : result
  end

#  def get_conflicts_of(foods)
#    result = []
#    return result if foods.size < 2
#    result
#  end


  def self.get_tiny_mce_style
     {
       :theme => 'advanced',
       :theme_advanced_toolbar_location => "top",
       :theme_advanced_toolbar_align => "left",
       :theme_advanced_resizing => true,
       :theme_advanced_resize_horizontal => false,
       :theme_advanced_buttons1 => %w{ formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent separator bullist numlist forecolor backcolor separator link unlink image undo redo},
       :theme_advanced_buttons2 => [],
       :theme_advanced_buttons3 => []
     }
   end

  def get_region(region_id)
    if region_id.present?
      city = City.first(:conditions => {:id => region_id})
      if city
        return city
      else
        province = Province.first(:conditions => {:id => region_id})
        return province if province
      end
    end

    nil
  end

  def get_hot_tags
    tags = Rails.cache.read('hot_tags')
    if tags.blank?
      tags = InfoItem.tags_with_weight[0..GlobalConstants::CACHED_HOT_TAGS].map{ |e| e[0] }
      Rails.cache.write("hot_tags", tags)
    end
    tags
  end

  def get_all_tags
    tags = Rails.cache.read('all_tags')
    if tags.blank?
      tags = InfoItem.tags
      Rails.cache.write("all_tags", tags)
    end
    tags
  end
end
