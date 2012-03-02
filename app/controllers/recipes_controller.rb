class RecipesController < ApplicationController
  before_filter :preload
  before_filter(:except => [:index, :show, :more]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:edit, :update]) {|c| c.the_author_himself(@recipe, false, true)}
  before_filter(:only => [:delete]) {|c| c.the_author_himself(@recipe, true, true)}

  # GET /recipes
  # GET /recipes.json
  def index
    @hot_tags = get_hot_tags(14, :recipes)
    @primary_tags = get_primary_tag_names

    @recipes, @total_chapters = get_recipes(params[:tag], params[:page], params[:chapter])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    @recipes, dummy = get_recipes(params[:tag], params[:page])

    respond_to do |format|
      format.html { render :more, layout: false}
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
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
      @recipe.steps.build
      @recipe.ingredients.build {|i| i.is_major_ingredient = true }
      @recipe.ingredients.build {|i| i.is_major_ingredient = false }
    }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit

  end

  # POST /recipes
  # POST /recipes.json
  def create
    params[:recipe][:steps_attributes] = sort_steps(params[:recipe][:steps_attributes])

    @recipe = Recipe.new(params[:recipe])
    @recipe.author_id = current_user.id

    saved = @recipe.save

    if saved
      #create a desire&solution as well
      image_id = nil
      image = nil
      @recipe.steps.each do |step|
        image_id = step.img_id if step.img_id.present?
      end
      image = Image.first(conditions: {id: image_id}) if image_id
      if image
        desire = Desire.create do |d|
          d.author = current_user
          d.content = current_user.login_name + I18n.t("desires.new_recipe", name: @recipe.name)
          cloned_image = image.clone
          d.images << cloned_image
        end

        desire.solutions.create do |s|
          s.recipe_id = @recipe.id
          s.author = current_user
        end
      end
    end

    respond_to do |format|
      if saved
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
    #delete ingredients removed by user
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

  def mark
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

  def preload
    @recipe = Recipe.find(params[:id]) if params[:id].present?
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


  def get_recipes(tag, page, chapter = nil)
    total_chapters = 0
    if chapter.present?
      chapter = chapter.to_i
    elsif session[:current_recipes_chapter].present?
      chapter = session[:current_recipes_chapter].to_i
    else
      chapter = 1
    end
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

