class DesiresController < ApplicationController
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Desire.name, c.params[:id], true)}

  # GET /desires
  # GET /desires.json
  def index
    @primary_tags = get_primary_tags
    @desires = get_desires(params[:tag], 1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @desires }
    end
  end

  def more
    @desires = get_desires(params[:tag] , params[:page])

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

    respond_to do |format|
      format.html {render "afar", :layout => "dialog"}
    end
  end

  private

  def get_desires(tag = nil, page = 1)
    criteria = Desire.all
    if tag.present? && tag != "null"
      criteria = criteria.tagged_with(tag)
    end
    @desires = criteria.desc(:created_at).page(page).per(ITEMS_PER_PAGE_FEW)
  end

end
