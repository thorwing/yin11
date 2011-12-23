class RecipesController < ApplicationController
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Recipe.name, c.params[:id], true)}
  # GET /recipes
  # GET /recipes.json
  def index
    @hot_tags = Rails.cache.fetch('hot_tags')
    if @hot_tags.nil?
       Logger.new(STDOUT).info "hot_tags are cached"
       @hot_tags = Recipe.tags_with_weight[0..7]
       Rails.cache.write('hot_tags', @hot_tags, :expires_in => 5.hours)
    end

    #@hot_tags = Rails.cache.fetch('hot_tags', :expires_in => 5.hours){ Recipe.tags_with_weight[0..7] }
    #@records = Rails.cache.read('records', :expires_in => 5.hours){ YAML::load(File.open("app/seeds/tags.yml"))}

    @records = Rails.cache.fetch('records')
    if @records.nil?
       Logger.new(STDOUT).info "records are cached"
       @records = YAML::load(File.open("app/seeds/tags.yml"))
       Rails.cache.write('records', @records, :expires_in => 5.hours)
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    criteria = Recipe.all.desc(:created_at)
    criteria = criteria.tagged_with(params[:tag]) if params[:tag].present?
    @recipes = criteria.page(params[:page]).per(ITEMS_PER_PAGE_FEW)

    data = {
      items: @recipes.inject([]){|memo, r| memo << {
        name: r.name,
        content: r.instruction,
        picture_url: r.get_image_url(:waterfall),
        picture_height: r.get_image_height(:waterfall),
        user_id: r.author.id,
        user_name: r.author.screen_name,
        user_avatar: r.author.get_avatar(:thumb, false),
        user_reviews_cnt: r.author.reviews.count,
        user_recipes_cnt: r.author.recipes.count,
        user_fans_cnt: r.author.followers.count,
        time: r.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        id: r.id}
      },
      page: params[:page],
      pages: (Recipe.all.size.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil
    }

    respond_to do |format|
      format.json { render :json => data}
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipe = Recipe.find(params[:id])
    prior = {"user_tag"=> 3, "major_tag" => 2, "minor_tag" => 1}
    @related_products = get_related_products(@recipe, 7, prior)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.json
  def new

    @recipe = Recipe.new

    1.upto(3) {
      step = @recipe.steps.build
    }
    1.upto(5) {
      ingredient = @recipe.ingredients.build
    }

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
    #p "params[:recipe]" + params[:recipe][:steps_attributes].to_s
    @recipe = Recipe.new(params[:recipe])
    #p "screen_name: " + current_user.screen_name
    @recipe.author_id = current_user.id
    #p "@recipe: " + @recipe.to_yaml

    #steps = params[:recipe][:steps_attributes]
    #steps.each do |s|
    #  p s.class.name
    #  p "s: " + s.to_s
    #end


    #p "_____________"

    #@recipe.steps.each do |s|
    #  p "s.img_id" +  s.img_id
    #end

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: t("notices.recipe_created") }
        format.json { render json: @recipe, status: :created, location: @recipe }
      else
        #raise("hi")
        format.html { render action: "new" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.json
  def update
    @recipe = Recipe.find(params[:id])

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
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url }
      format.json { head :ok }
    end
  end

  def mark
    @recipe = Recipe.find(params[:id])
    @review = @recipe.reviews.new(content: params[:content])
    @review.author = current_user
    @review.save!
    @user_message = t("notices.review_posted")

    respond_to do |format|
      format.js
    end
  end

  #for non-action methods
  private

  def get_related_products(recipe, max, prior)
    @major_tags= []
    @minor_tags = []
    @recipe.ingredients.each do |ingredient|
      if ingredient.is_major_ingredient
        #TODO  for ingredient.name.strip , strip is not necessory, name should be striped before save
        @major_tags << ingredient.name.strip
      else
        @minor_tags << ingredient.name.strip
      end
    end
    @user_tags = @recipe.tags - @major_tags - @minor_tags

    user_product = Product.tagged_with(@user_tags).limit(max* @user_tags.length)
    major_product = Product.tagged_with(@major_tags).limit(max* @major_tags.length)
    minor_product = Product.tagged_with(@minor_tags).limit(max* @minor_tags.length)

    hash = {}
    user_product.each do |product|
      hash[product] = product.reviews.size * prior["user_tag"]
      #3
    end

    major_product.each do |product|
      hash[product] = product.reviews.size * prior["major_tag"]
    end

    minor_product.each do |product|
      hash[product] = product.reviews.size * prior["minor_tag"]
    end

    #p "before"
    #hash.each do |k,v|
    #   p k.to_s + "=>" + v.to_s
    #end

    hash = hash.sort_by { |k,v| -v }

    #p "after"
    #hash.each do |k,v|
    #   p k.to_s + "=>" + v.to_s
    #end

    related_product = []
    count = hash.size-1 > max ? max : hash.size-1
    for i in 0..count
      related_product << hash[i].first
    end
    return related_product
  end
end

