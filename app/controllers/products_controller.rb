class ProductsController < ApplicationController
  before_filter(:except => [:index, :show, :more, :link]) { |c| c.require_permission :editor }

  # GET /products
  # GET /products.json
  def index
    @catalogs = Catalog.desc(:created_at).to_a
    @products, @total_chapters = get_products(params[:tag], params[:page],  params[:chapter])
    session[:current_products_chapter] = params[:chapter]

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def more
    @products, dummy = get_products(params[:tag], params[:page], session[:current_products_chapter])

    respond_to do |format|
      format.html
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    limit = 6
    @related_products = Product.tagged_with(@product.tags).limit(RELATED_RPODUCTS_LIMIT).reject{|p| p == @product}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  def link
    @valid_url, @product = SilverHornet::TopHornet.new.fetch_product(params[:product_url])

    respond_to do |format|
      format.js
    end
  end

  private

  def get_products(tag, page, chapter = nil)
    total_chapters = 0
    chapter = (chapter.present? ? chapter.to_i : 1)
    page = (page ? page.to_i : 1)
    if page <= PAGES_PER_CHAPTER
      criteria = Product.enabled.desc(:created_at)
      #if params[:catalog].present?
      #  catalog = Catalog.first(conditions: {name: params[:catalog]})
      #  catalog_ids = [catalog.id] | catalog.descendant_ids
      #  criteria = criteria.any_in(catalog_ids: catalog_ids)
      #end

      if tag.present? && tag != "null"
        criteria = criteria.tagged_with(tag)
      end
      total_chapters = (criteria.size.to_f / PAGES_PER_CHAPTER.to_f / ITEMS_PER_PAGE_FEW.to_f).ceil

      return criteria.page((chapter - 1) * PAGES_PER_CHAPTER + page).per(ITEMS_PER_PAGE_FEW), total_chapters
    else
      return [], total_chapters
    end
  end
end
