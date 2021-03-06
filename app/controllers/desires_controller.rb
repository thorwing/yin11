class DesiresController < ApplicationController
  before_filter :preload
  before_filter(:except => [:index, :show, :more, :feed]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(@desire, false, true)}
  before_filter(:only => [:delete]) {|c| c.the_author_himself(@desire, true, true)}

  # GET /desires
  # GET /desires.json
  def index
    @primary_tags = get_primary_tags

    @desires, @total_chapters = get_desires( params[:tag], params[:page], params[:chapter])
    session[:current_desires_chapter] = params[:chapter]

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    @desires, dummy = get_desires(params[:tag], params[:page], session[:current_desires_chapter])

    respond_to do |format|
      format.html { render :more, layout: false}
    end
  end

  # GET /desires/1
  # GET /desires/1.json
  def show
    @related_desires = Desire.tagged_with(@desire.tags).excludes(id: @desire.id).desc(:created_at).limit(9)
    #TODO incorrect sorting
    @solutions = @desire.solutions.desc(:score, :created_at).page(params[:page]).per(ITEMS_PER_PAGE_FEW) #.uniq{|s| s.identity} #.to_a.reject{|s| s.item.blank? || s.item.get_image_url.blank?}

    @modes = ["solutions", "comments"]
    set_mode(:personal_mode, @modes, params[:mode], "solutions")

    #votes = @solutions.inject([]){|memo, s| memo | s.votes }.sort{|x, y| y.created_at <=> x.created_at}
    #@my_vote = votes.select{|v| v.voter_id == current_user.id.to_s}.first if current_user

    #dummy ojbect for new_solution_field
    #dummy = Solution.new
    #if @solutions.empty?
    #  @solutions += [dummy]
    #else
    #  @solutions = @solutions.each_slice(8).inject([]){|memo, group| memo + (group << dummy)}
    #end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @desire }
    end
  end

  # GET /desires/new
  # GET /desires/new.json
  def new
    @desire = Desire.new
    if params[:place_id].present?
      @place = Place.find(params[:place_id])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @desire }
    end
  end

  # GET /desires/1/edit
  def edit

  end

  # POST /desires
  # POST /desires.json
  def create
    @desire = Desire.new(params[:desire])
    #@desire.content = @desire.content[0..MAX_DESIRE_CONTENT_LENGTH - 1] if (@desire.content.present? && @desire.content.size > MAX_DESIRE_CONTENT_LENGTH)
    @desire.author = current_user

    PlacesHelper.process_place(@desire, params[:place][:city], params[:place][:name], params[:place][:street])

    ImagesHelper.process_uploaded_images(@desire, params[:images], params[:remote_image_url])

    saved = @desire.save
    if saved
      SolutionManager.generate_product_solution(@desire, params[:product_id], current_user) if params[:product_id].present?
      SolutionManager.generate_tuan_solution(@desire, params[:tuan_id], current_user) if params[:tuan_id].present?
    end

    respond_to do |format|
      if saved
        format.html { redirect_to @desire, notice: t("notices.desire_created") }
        format.json { render json: @desire, status: :created, location: @desire }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @desire.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /desires/1
  # PUT /desires/1.json
  def update
    ImagesHelper.process_uploaded_images(@desire, params[:images])

    PlacesHelper.process_place(@desire, params[:place][:city], params[:place][:name], params[:place][:street])
    #SolutionManager.generate_solutions(@desire)

    respond_to do |format|
      if @desire.update_attributes(params[:desire])
        format.html { redirect_to @desire, notice: t("notices.desire_updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @desire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /desires/1
  # DELETE /desires/1.json
  def destroy
    @desire.destroy

    respond_to do |format|
      format.html { redirect_to desires_url }
      format.json { head :ok }
    end
  end

  def admire
    if (@desire.admirer_ids.include? current_user.id)
      @desire.admirers.delete(current_user)
    else
      @desire.admirers << current_user

      unless @desire.history_admirer_ids.include? current_user.id
        RewardManager.reward_for_admire(@desire, current_user)
      end
    end

    respond_to do |format|
      if @desire.save
        format.js {render :content_type => 'text/javascript'}
      else
        format.js { head :unprocessable_entity }
      end
    end
  end

  def afar
    @desire = Desire.new
    dummy, @product = SilverHornet::TopHornet.new.fetch_product(params[:url])
    @tuan = SilverHornet::TuanHornet.new.fetch_tuan(params[:url])

    respond_to do |format|
      format.html {render "afar", :layout => "dialog"}
    end
  end

  def feed
    @desires = Rails.cache.fetch('desires_feed')
    if @desires.nil?
      @desires = Desire.recommended.only(:content, :author, :id, :created_at).desc(:created_at).limit(20)
      Rails.cache.write('desires_feed', @desires, :expires_in => 30.minutes)
    end

    respond_to do |format|
      #format.html
      format.rss { render :layout => false } #index.rss.builder
    end
  end

  private

  def get_desires(tag, page, chapter)
    total_chapters = 0

    chapter = (chapter.present? ? chapter.to_i : 1)
    page = (page ? page.to_i : 1)
    if page <= PAGES_PER_CHAPTER
      criteria = Desire.all
      if tag.present? && tag != "null"
        criteria = criteria.tagged_with(tag)
      end
      total_chapters = (criteria.size.to_f / PAGES_PER_CHAPTER.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil

      return criteria.desc(:created_at).page((chapter - 1) * PAGES_PER_CHAPTER + page).per(ITEMS_PER_PAGE_FEW), total_chapters
    else
      return [], total_chapters
    end
  end

  def preload
    @desire = Desire.find(params[:id]) if params[:id].present?
  end

end
