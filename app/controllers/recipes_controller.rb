class RecipesController < ApplicationController
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(Recipe.name, c.params[:id], true)}
  # GET /recipes
  # GET /recipes.json
  def index
    t@hot_tags = Recipe.tags_with_weight
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    criteria = Recipe.all
    criteria = criteria.tagged_with(params[:tag]) if params[:tag].present?
    @recipes = criteria.page(params[:page]).per(ITEMS_PER_PAGE_FEW)

    data = {
      items: @recipes.inject([]){|memo, r| memo << {
        name: r.recipe_name,
        picture_url: r.steps.last == nil ? 'no-pic' : r.image_url,
        user_id: r.author.id,
        user_name: r.author.screen_name,
        user_avatar: r.author.get_avatar(true, false),
        user_reviews_cnt: r.author.reviews.count,
        user_recipes_cnt: r.author.recipes.count,
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
    @related_product = get_related_products(@recipe, 7, prior)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.json
  def new

    @recipe = Recipe.new
    ingredient = @recipe.ingredients.build
    1.upto(3) {
      step = @recipe.steps.build
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
    #p "params[:recipe]" + params[:recipe].to_yaml
    @recipe = Recipe.new(params[:recipe])
    #p "screen_name: " + current_user.screen_name
    @recipe.author_id = current_user.id
    #p "@recipe: " + @recipe.to_yaml

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
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
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
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

