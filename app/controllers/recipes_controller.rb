class RecipesController < ApplicationController
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Recipe.name, c.params[:id], true)}

  # GET /recipes
  # GET /recipes.json
  def index
    @hot_tags = get_hot_tags(14, :recipes)
    @primary_tags = get_primary_tags

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    criteria = Recipe.all.desc(:created_at)
    criteria = criteria.tagged_with(params[:tag]) if params[:tag].present?
    @recipes = criteria.page(params[:page]).per(ITEMS_PER_PAGE_FEW).reject{|r| r.image.blank?}

    data = {
      items: @recipes.inject([]){|memo, r| memo << {
        name: r.name,
        content: r.instruction,
        picture_url: r.get_image_url(:waterfall),
        picture_height: r.get_image_height(:waterfall),
        user_id: r.author.id,
        user_name: r.author.login_name,
        user_avatar: r.author.get_avatar(:thumb, false),
        user_reviews_cnt: r.author.reviews.count,
        user_recipes_cnt: r.author.recipes.count,
        user_fans_cnt: r.author.followers.count,
        time: r.created_at.strftime("%m-%d %H:%M:%S"),
        id: r.id}
      },
      page: params[:page],
      pages: (criteria.size.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil
    }

    respond_to do |format|
      format.json { render :json => data}
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipe = Recipe.find(params[:id])
    #TODO
    @related_recipes = Recipe.tagged_with(@recipe.tags).excludes(id: @recipe.id).limit(10).reject{|r| r.image.blank?}
    prior = {"user_tag"=> 3, "major_tag" => 2, "minor_tag" => 1}
    @related_products = get_related_products(@recipe, RELATED_RPODUCTS_LIMIT, prior)

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

    1.upto(3) {
      ingredient = @recipe.ingredients.build
      ingredient.is_major_ingredient = true;
    }
    1.upto(5) {
      ingredient = @recipe.ingredients.build
      ingredient.is_major_ingredient = false;
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
    #after Click on and drag sort, the sequence may not in the right order
    newhash = {}
    params[:recipe][:steps_attributes].each_with_index do |(key, value), index|
       #p "key: #{key}, value: #{value}, index: #{index}\n"
       newhash[index]= value
    end
    params[:recipe][:steps_attributes] =  newhash
    #reordered

    @recipe = Recipe.new(params[:recipe])
    @recipe.author_id = current_user.id

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
    #after Click on and drag sort, the sequence may not in the right order
    newhash = {}
    params[:recipe][:steps_attributes].each_with_index do |(key, value), index|
       value.delete("id")
       newhash[index]= value
    end
    params[:recipe][:steps_attributes]= newhash
    #reordered

    @recipe = Recipe.find(params[:id])

    #record all ingredients in db
    database_ingredient_ids = @recipe.ingredients.map{|s| s.id.to_s }

    #delete all old images
    Image.any_in(step_id: @recipe.steps.map(&:id)).delete_all
    @recipe.steps.delete_all
    saved = @recipe.update_attributes(params[:recipe])
    if saved
      params_ingredient_ids = params[:recipe][:ingredients_attributes].map{|k,v| v["id"]}
      to_be_deleted_ingredient_ids = database_ingredient_ids - params_ingredient_ids
      @recipe.ingredients.any_in(_id: to_be_deleted_ingredient_ids).delete_all
    end

    respond_to do |format|
      if saved
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
    end

    major_product.each do |product|
      hash[product] = product.reviews.size * prior["major_tag"]
    end

    minor_product.each do |product|
      hash[product] = product.reviews.size * prior["minor_tag"]
    end

    hash = hash.sort_by { |k,v| -v }

    related_product = []
    count = hash.size-1 > max ? max : hash.size-1
    for i in 0..count
      related_product << hash[i].first
    end
    return related_product
  end
end

