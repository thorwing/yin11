class RecipesController < ApplicationController
  # GET /recipes
  # GET /recipes.json
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    @recipes = Recipe.all.page(params[:page]).per(ITEMS_PER_PAGE_FEW)
    data = {
      items: @recipes.inject([]){|memo, p| memo << {
        name: p.recipe_name,
        picture_url: p.steps.last == nil ? 'no-pic' : Image.find(p.steps.last.img_id).picture_url,
        id: p.id}
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.json
  def new
    @recipe = Recipe.new
    #ingredient = @recipe.ingredients.build
    #step = @recipe.steps.build

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
      if @recipe.save!
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render json: @recipe, status: :created, location: @recipe }
      else
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
end
