class RecipesController < ApplicationController
  before_filter :preload
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(@recipe, false, true)}
  before_filter(:only => [:delete]) {|c| c.the_author_himself(@recipe, true, true)}

  # GET /recipes
  # GET /recipes.json
  def index
    all_tags_with_weight = get_all_tags(:recipes)
    @tag_weight_hash = {}
    all_tags_with_weight.each do |tag_with_weight|
      @tag_weight_hash[tag_with_weight[0]] = tag_with_weight[1]
    end
    all_tags = all_tags_with_weight.map{|t| t[0]}
    @primary_tags = get_primary_tag_names(all_tags)
    @hot_custom_tags = (all_tags - flatten_tags(@primary_tags)).take(10)

    if params[:tag].blank?
      @new_recipes = Recipe.desc(:created_at).limit(10)
      @recommended_recipes = Recipe.desc(:priority).limit(4)

      #TODO
      @cooks = User.desc(:recipes_count).limit(10).reject{|u| u.avatar.blank?}.take(5)

      @recipes = Recipe.desc(:created_at).page(params[:page]).per(30)
    else
      @recipes = Recipe.tagged_with(params[:tag]).desc(:created_at).page(params[:page]).per(30)
    end

    #@recipes, @total_chapters = get_recipes(params[:tag], params[:page], params[:chapter])
    #session[:current_recipes_chapter] = params[:chapter]

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    @recipes, dummy = get_recipes(params[:tag], params[:page], session[:current_recipes_chapter])

    respond_to do |format|
      format.html { render :more, layout: false}
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    #TODO
    @related_recipes = Recipe.tagged_with(@recipe.tags).excludes(id: @recipe.id).limit(10).reject{|r| r.image.blank?}.sort{|x, y| (y.tags & @recipe.tags).size <=> (x.tags & @recipe.tags).size }
    #prior = {"user_tag"=> 3, "major_tag" => 2, "minor_tag" => 1}
    @related_products = []#get_related_products(@recipe, RELATED_RPODUCTS_LIMIT, prior)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.json
  def new
    session[:recipe_stage] = nil
    session[:recipe_params] = {} # ||= {}
    @recipe = Recipe.new  #Recipe.new(session[:recipe_params])
    @recipe.current_stage = @recipe.stages.first #session[:recipe_stage]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
    @recipe = Recipe.find(params[:id])
  end

  # POST /recipes
  # POST /recipes.json
  def create
    #@recipe = Recipe.new(params[:recipe])
    if params[:recipe] && params[:steps_attributes]
      sort_steps(params[:recipe][:steps_attributes])
    end

    saved = false
    notice = nil
    session[:recipe_params] ||= {}
    session[:recipe_params].deep_merge!(params[:recipe]) if params[:recipe]
    @recipe = Recipe.new(session[:recipe_params]) do |r|
      r.author_id = current_user.id
      r.current_stage = session[:recipe_stage]
    end

    if @recipe.valid?
      if params[:back_button]
        @recipe.previous_stage
      elsif @recipe.last_stage?
        @recipe.create_image(picture: params[:image])
        saved = @recipe.save
      else
        @recipe.next_stage
      end

      if @recipe.current_stage == "detail"
        @similar_recipes = Recipe.where(name: @recipe.name)

        1.upto(3) {
          @recipe.ingredients.build {|i| i.is_major_ingredient = true }
          @recipe.ingredients.build {|i| i.is_major_ingredient = false }
        }

        1.upto(4) {
          @recipe.steps.build
        }
      end

      session[:recipe_stage] = @recipe.current_stage
    end

    if saved
      session[:recipe_stage] =  session[:recipe_params] =  nil
      redirect_to url_for(contriller: "recipes", action: "show", id: @recipe.id, newly_created: true), notice: t("notices.recipe_created")
    else
      render "new", notice: notice
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.json
  def update
    #delete ingredients removed by user
    if params[:image].present?
      @recipe.image.update_attributes(picture: params[:image])
    end

    ingredient_ids_to_be_deleted = @recipe.ingredients.map{|i| i.id.to_s } - params[:recipe][:ingredients_attributes].map{|k,v| v["id"]}
    @recipe.ingredients.any_in(_id: ingredient_ids_to_be_deleted).delete_all

    #delete steps removed by user
    step_ids_to_be_deleted = @recipe.steps.map{|s| s.id.to_s } - params[:recipe][:steps_attributes].map{|k,v| v["id"]}
    Image.any_in(step_id: step_ids_to_be_deleted).delete_all
    @recipe.steps.delete_all

    params[:recipe][:steps_attributes] = sort_steps(params[:recipe][:steps_attributes])

    respond_to do |format|
      if @recipe.update_attributes(params[:recipe])
        format.html { redirect_to @recipe, notice: t("notices.recipe_updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url }
      format.json { head :ok }
    end
  end

  def browse
    if params[:name].present?
      # not case sensitive
      @recipes = Recipe.where(name: /#{params[:name]}/i)
    end
    @recipes ||= []

    respond_to do |format|
      format.js
    end
  end

  def seduce
    #create a desire&solution as well
    desire = nil
    if @recipe.image
      desire = Desire.create do |d|
        d.author = @recipe.author
        d.content = params[:content]
        cloned_image = @recipe.image.clone
        d.images << cloned_image
      end

      desire.solutions.create do |s|
        s.recipe_id = @recipe.id
        s.author = @recipe.author
      end
    end

    respond_to do |format|
      if desire
        format.html { redirect_to desire, notice: t("notices.desire_created") }
      else
        format.html { redirect_to :back,  notice: t("alerts.fail_to_create_desire")}
      end
    end
  end

  #for non-action methods
  private

  def preload
    @recipe = Recipe.find(params[:id]) if params[:id].present?
  end

  def get_related_products(recipe, max, prior)
    #@major_tags= []
    #@minor_tags = []
    #@recipe.ingredients.each do |ingredient|
    #  if ingredient.is_major_ingredient
    #    #TODO  for ingredient.name.strip , strip is not necessory, name should be striped before save
    #    @major_tags << ingredient.name.strip
    #  else
    #    @minor_tags << ingredient.name.strip
    #  end
    #end
    #@user_tags = @recipe.tags - @major_tags - @minor_tags
    #
    #user_product = Product.tagged_with(@user_tags).limit(max* @user_tags.length)
    #major_product = Product.tagged_with(@major_tags).limit(max* @major_tags.length)
    #minor_product = Product.tagged_with(@minor_tags).limit(max* @minor_tags.length)
    #
    #hash = {}
    #user_product.each do |product|
    #  hash[product] = product.reviews.size * prior["user_tag"]
    #end
    #
    #major_product.each do |product|
    #  hash[product] = product.reviews.size * prior["major_tag"]
    #end
    #
    #minor_product.each do |product|
    #  hash[product] = product.reviews.size * prior["minor_tag"]
    #end
    #
    #hash = hash.sort_by { |k,v| -v }
    #
    #related_product = []
    #count = hash.size-1 > max ? max : hash.size-1
    #for i in 0..count
    #  related_product << hash[i].first
    #end
    #return related_product
    []
  end

  def sort_steps(old_attributes)
    #after Click on and drag sort, the sequence may not be in the right order
    new_attributes = {}
    old_attributes.each_with_index do |(old_index, value), correct_index|
      #must clear id incase the step has alrady been deleted
      value.delete("id")
      new_attributes[correct_index]= value
    end

    new_attributes
  end


  def get_recipes(tag, page, chapter)
    total_chapters = 0
    chapter = (chapter.present? ? chapter.to_i : 1)
    page = (page ? page.to_i : 1)
    if page <= PAGES_PER_CHAPTER
      criteria = Recipe.all
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

