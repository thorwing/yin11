class HomeController < ApplicationController
  include ApplicationHelper

  def index
    #@hot_topics = Topic.recommended.asc(:priority).limit(HOT_TOPICS_ON_HOME_PAGE)
    #@recommended_albums = Album.recommended.desc(:priority).limit(RECOMENDED_ALBUMS_ON_HOME_PAGE)
    #@stars = User.enabled.masters.sort_by{|master| -1 * master.score}[0..7]
    @hot_tags = get_hot_tags(7, :desires)

    @modes = ["newest", "hottest"]
    if params[:mode].present?
      @current_mode = params[:mode]
    end

    unless @modes.include? @current_mode
      @current_mode = "newest"
    end

    @desires = get_desires(@current_mode, 1)
  end

  def more_desires
    if params[:page].to_i <= PAGES_PER_CHAPTER
      @desires = get_desires(params[:mode], params[:page])
    end
    @desires ||= []

    respond_to do |format|
      format.html {render :more_desires, :layout => false}
    end
  end

  def gateway
    user_ip = request.remote_ip
    user_id = current_user ? current_user.id : nil
    product_url = params[:url]

    @audit = Audit.create(:user_ip => user_ip, :user_id => user_id, :product_url => product_url )
    redirect_to product_url
  end

  def collect_intro

  end

  private

  def get_desires(mode, page = 1)
    desires = []
    criteria = Desire.all
    if mode == "hottest"
      desires = criteria.desc(:admirer_ids).page(page).per(ITEMS_PER_PAGE_FEW)
    elsif mode == "newest"
      desires = criteria.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
    end

    desires
  end
end
