class DesiresController < ApplicationController
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Desire.name, c.params[:id], true)}

  # GET /desires
  # GET /desires.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @desires }
    end
  end

  def more
    #  used for waterfall displaying
    criteria = Desire.all.desc(:created_at) #votes
    criteria = criteria.tagged_with(params[:tag]) if params[:tag].present?
    @desires = criteria.page(params[:page]).per(ITEMS_PER_PAGE_FEW).select{|d| d.get_image_url(:waterfall).present?}

    data = {
      items: @desires.inject([]){|memo, d| memo <<  {
        content: d.content,
        user_id: d.author.id,
        user_name: d.author.login_name,
        user_avatar: d.author.get_avatar(:thumb, false),
        user_reviews_cnt: d.author.reviews.count,
        user_recipes_cnt: d.author.recipes.count,
        user_fans_cnt: d.author.followers.count,
        user_established: current_user ? (current_user.relationships.select{|rel| rel.target_type == "User" && rel.target_id == d.author.id.to_s}.size > 0) : false,
        time: d.created_at.strftime("%m-%d %H:%M:%S"),
        picture_url: d.get_image_url(:waterfall),
        picture_height: d.get_image_height(:waterfall),
        id: d.id}
      },
      page: params[:page],
      pages: (criteria.size.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil
    }

    respond_to do |format|
      format.json { render :json => data}
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
    @desire.author = current_user

    ImagesHelper.process_uploaded_images(@desire, params[:images], params[:remote_image_url])

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
      @success = true
    else
      @desire.admirers << current_user

      @success = true
    end

    if @success
      NotificationsManager.generate!(@desire.author, current_user, "admire", @desire )
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

    respond_to do |format|
      format.html {render "afar", :layout => "dialog"}
    end
  end
end
