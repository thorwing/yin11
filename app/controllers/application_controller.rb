class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :layout
  before_filter :set_locale, :set_city
  helper_method :current_user, :current_city
  helper_method :get_related_reviews_of, :get_related_articles_of, :the_author_himself, :get_region
  FOOD_ARTICLES_LIMIT = 5
  FOOD_REVIEWS_LIMIT = 5

  def current_user
    @current_user ||= User.first(:conditions => {:auth_token => cookies[:auth_token]}) if cookies[:auth_token]
  end

  def current_city
    @current_city ||= City.find(session[:current_city])
  end

  def current_city=(new_city)
    @current_city = new_city
    session[:current_city] = new_city.id
  end

  protected
  def set_locale
    I18n.locale = "zh-CN"
  end

  def set_city
    #should be set only once
    unless session[:current_city]
      city = City.first(:conditions => {:name_en => request.location.city.upcase})
      #TODO
      city ||= City.first(:conditions => {:name => t("system.default_city")})
      session[:current_city] = city.id
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

  #TODO
  def require_permission(permission)
    if current_user && current_user.has_permission?(permission)
      true
    else
      current_user ? (redirect_away :root, :notice => t("notices.need_permission_not_logged", :permission => t("roles.normal_user") )) : (redirect_away :log_in, :notice => t("notices.need_permission_logged", :permission => permission))
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
