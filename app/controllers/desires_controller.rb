class DesiresController < ApplicationController
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Desire.name, c.params[:id], true)}

  # GET /desires
  # GET /desires.json
  def index
    @primary_tags = get_primary_tags

    @desires, @total_chapters = get_desires( params[:tag], params[:page], params[:chapter])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    @desires, dummy = get_desires(params[:tag], params[:page])

    respond_to do |format|
      format.html { render :more, layout: false}
    end
  end

  # GET /desires/1
  # GET /desires/1.json
  def show
    @desire = Desire.find(params[:id])
    @related_desires = Desire.tagged_with(@desire.tags).excludes(id: @desire.id).desc(:admirer_ids, :created_at).limit(9)

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
    @desire = Desire.find(params[:id])
  end

  # POST /desires
  # POST /desires.json
  def create
    @desire = Desire.new(params[:desire])
    #@desire.content = @desire.content[0..MAX_DESIRE_CONTENT_LENGTH - 1] if (@desire.content.present? && @desire.content.size > MAX_DESIRE_CONTENT_LENGTH)
    @desire.author = current_user

    if params[:place][:name].present? && params[:place][:street].present?
      place = Place.find_or_initialize_by(name: params[:place][:name])
      if place.new_record?
        place.city = params[:place][:city]
        place.street = params[:place][:street]
        place.save
      end
      @desire.place = place
    end

    ImagesHelper.process_uploaded_images(@desire, params[:images], params[:remote_image_url])

    if params[:product_id].present?
      product = Product.find(params[:product_id])
      #create a review as well
      product.reviews.create do |r|
        r.author = current_user
        r.desire = @desire
        r.content = product.name
      end
    end

    respond_to do |format|
      if @desire.save
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
    @desire = Desire.find(params[:id])

    ImagesHelper.process_uploaded_images(@desire, params[:images])

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
    @desire = Desire.find(params[:id])
    @desire.destroy

    respond_to do |format|
      format.html { redirect_to desires_url }
      format.json { head :ok }
    end
  end

  def admire
    @desire = Desire.find(params[:id])
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

    valid_url, @product = handle_taobao_product(params[:url])

    respond_to do |format|
      format.html {render "afar", :layout => "dialog"}
    end
  end

  private

  def get_desires(tag, page, chapter = nil)
    total_chapters = 0
    if chapter.present?
      chapter = chapter.to_i
    elsif session[:current_desires_chapter].present?
      chapter = session[:current_desires_chapter].to_i
    else
      chapter = 1
    end
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

end
