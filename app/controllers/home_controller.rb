class HomeController < ApplicationController
  include ApplicationHelper

  def index
    #@hot_topics = Topic.recommended.asc(:priority).limit(HOT_TOPICS_ON_HOME_PAGE)
    #@recommended_albums = Album.recommended.desc(:priority).limit(RECOMENDED_ALBUMS_ON_HOME_PAGE)
    #@stars = User.enabled.masters.sort_by{|master| -1 * master.score}[0..7]

    #SilverHornet::TuanHornet.new.fetch_all_tuans("lashou")

    @hot_tags = get_all_tags(:desires).take(10)

    @modes = ["newest", "solved"] #"hottest"
    if @modes.include? params[:mode]
      @current_mode = params[:mode]
    else
      @current_mode = "newest"
    end

    @awards = Award.limit(4)

    @desires, @total_chapters = get_desires( @current_mode, params[:page], params[:chapter])
    session[:current_home_chapter] = params[:chapter]
  end

  def more_desires
    @desires, dummy = get_desires(params[:mode], params[:page], session[:current_home_chapter])

    respond_to do |format|
      format.html {render :more_desires, :layout => false}
    end
  end

  def gateway
    user_ip = request.remote_ip
    user_id = current_user ? current_user.id : nil
    url = params[:url]

    @audit = Audit.create(:user_ip => user_ip, :user_id => user_id, :url => url )
    redirect_to url
  end

  private

  def get_desires(mode, page, chapter)
    total_chapters = Rails.cache.fetch('total_desires_chapters')
    if total_chapters.nil?
      total_chapters = (Desire.enabled.size.to_f / PAGES_PER_CHAPTER.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil
      Rails.cache.write('total_desires_chapters', total_chapters, :expires_in => 1.minutes)
    end

    chapter = (chapter.present? ? chapter.to_i : 1)
    page = (page.present? ? page.to_i : 1)
    criteria = Desire.enabled
    desires = []

    if page <= PAGES_PER_CHAPTER
      real_page_nr = (chapter - 1) * PAGES_PER_CHAPTER + page

      if mode == "hottest"
        desires = criteria.desc(:admirer_ids, :priority, :created_at).page(real_page_nr).per(ITEMS_PER_PAGE_FEW)
      elsif mode == "solved"
        criteria = criteria.where(:solutions_count.gt => 0).desc(:priority, :solved, :solutions_count, :admirer_ids, :created_at)
        total_chapters = (criteria.size.to_f / PAGES_PER_CHAPTER.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil
        desires = criteria.page(real_page_nr).per(ITEMS_PER_PAGE_FEW)
      elsif mode == "newest"
        desires = criteria.desc(:created_at).page(real_page_nr).per(ITEMS_PER_PAGE_FEW)
      end

      return desires, total_chapters
    else
      return [], total_chapters
    end
  end
end
