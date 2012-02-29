class HomeController < ApplicationController
  include ApplicationHelper

  def index
    #@hot_topics = Topic.recommended.asc(:priority).limit(HOT_TOPICS_ON_HOME_PAGE)
    #@recommended_albums = Album.recommended.desc(:priority).limit(RECOMENDED_ALBUMS_ON_HOME_PAGE)
    #@stars = User.enabled.masters.sort_by{|master| -1 * master.score}[0..7]
    @hot_tags = get_hot_tags(7, :desires)

    @modes = ["hottest", "newest"]
    if @modes.include? params[:mode]
      @current_mode = params[:mode]
    else
      @current_mode = "hottest"
    end

    @desires, @total_chapters = get_desires( @current_mode, params[:page], params[:chapter])
  end

  def more_desires
    @desires, dummy = get_desires(params[:mode], params[:page])

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

  def get_desires(mode, page = 1, chapter = nil)
    total_chapters = 0
    if chapter.present?
      chapter = chapter.to_i
    elsif session[:current_desires_chapter].present?
      chapter = session[:current_desires_chapter].to_i
    else
      chapter = 1
    end

    page = (page ? page.to_i : 1)
    criteria = Desire.all
    desires = []
    total_chapters = (criteria.size.to_f / PAGES_PER_CHAPTER.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil
    if page <= PAGES_PER_CHAPTER
      if mode == "hottest"
        desires = criteria.desc(:priority, :admirer_ids, :created_at).page((chapter - 1) * PAGES_PER_CHAPTER + page).per(ITEMS_PER_PAGE_FEW)
      elsif mode == "newest"
        desires = criteria.desc(:created_at).page((chapter - 1) * PAGES_PER_CHAPTER + page).per(ITEMS_PER_PAGE_FEW)
      end

      return desires, total_chapters
    else
      return [], total_chapters
    end
  end
end
