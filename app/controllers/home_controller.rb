class HomeController < ApplicationController
  include ApplicationHelper

  def index
    all_tags_with_weight = get_all_tags(:desires)
    @tag_weight_hash = {}
    all_tags_with_weight.each do |tag_with_weight|
      @tag_weight_hash[tag_with_weight[0]] = tag_with_weight[1]
    end
    all_tags = all_tags_with_weight.map{|t| t[0]}
    @primary_tags = get_primary_tag_names(all_tags)
    @hot_custom_tags = (all_tags - flatten_tags(@primary_tags)).take(20)

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
        criteria = criteria.where(:solutions_count.gt => 0).desc(:priority, :created_at, :admirer_ids )
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
