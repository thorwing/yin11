class ProfileController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }
  layout :resolve_layout

  def show
    #referesh
    @my_recent_reviews = current_user.info_items.where(:_type => "Review").desc(:updated_at).limit(3)
  end

  def edit
    current_user.profile.watching_addresses || current_user.profile.watching_addresses.build
    @my_recent_reviews = current_user.info_items.where(:_type => "Review").desc(:updated_at).limit(3)
  end

  def update
    if current_user.profile.update_attributes(params[:profile])
      redirect_to profile_show_path, :notice => t("profile.profile_updated_notice")
    else
      redirect_to profile_show_path, :notice => "Error"
    end
  end

  def edit_current_city
    respond_to do |format|
      if params[:popup]
        format.html {render "edit_current_city", :layout => "dialog" }
      else
        format.html # new.html.erb
      end
    end
  end

  def update_current_city
    self.current_city = City.find(params[:select_city]) if params[:select_city].present?
    @current_city = self.current_city

    respond_to do |format|
      format.js {render :content_type => 'text/javascript'}
    end
  end

  private
  def resolve_layout
    case action_name
      when 'edit'
        "map"
      else
        "application"
    end
  end

end
