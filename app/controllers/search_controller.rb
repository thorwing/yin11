class SearchController < ApplicationController
  before_filter :prepare

  def test_xs(str, escape=true)
      str.unpack('U*').map {|n| n.xchr(escape)}.join # ASCII, UTF-8
    rescue
      str.unpack('C*').map {|n| n.xchr}.join # ISO-8859-1, WIN-1252
  end

  def index
    #prepare parameters
    if @query.present?
      @items = []

      config = SilverSphinx::Configuration.instance
      config.indexed_models.each do |model|
        @items |= model.search(@query).documents
      end

      #client = Riddle::Client.new("localhost", 3312)
      #client.match_mode = :extended
      #raw_result = client.query "#{@query}"

      #result = SilverSphinx::Search.new(client, Article, raw_result)
      #raise result.documents.to_yaml

      ##search by location
      #city_names ||= []
      #city_names << @query if City.exists?(:conditions => {:name => @query})
      #province = Province.first(:conditions => {:name => @query})
      #city_names << province.cities.map(&:name) if province
      #is_by_location = !city_names.empty?
      #if is_by_location
      #  @query_criteria = @query_criteria.from_cities(city_names)
      #end
      #
      ##TODO
      ##search by tags
      #
      #all_tags = CacheManager.all_tags #get_all_tags
      #query_tags = @query.split(' ')
      #tags = all_tags & query_tags
      #is_by_tags = tags.size > 0
      #if is_by_tags
      #  @query_criteria = @query_criteria.tagged_with(tags)
      #end
      #
      ##search by title
      #unless (is_by_location || is_by_tags)
      #  @query_criteria = @query_criteria.where(:title => /#{@query}?}/)
      #end
      #
      #process_items
    end
  end

  def tag
    if @query.present?
      @query_criteria = @query_criteria.tagged_with(@query)

      process_items
    end

    respond_to do |format|
      format.html {render :index}
    end
  end

  def region
    if @query.present?
      @query_criteria = @query_criteria.from_cities([@query])

      process_items
    end
    respond_to do |format|
      format.html {render :index}
    end
  end

  protected

  def prepare
    @bad_items ||= []
    @good_items ||= []
    @bad_region_names ||= []
    @tips = []

    @query = params[:query] || params[:tags] || params[:region_name]
    @query_criteria = InfoItem.enabled
  end

  def process_items
    #TODO
    @bad_count = @query_criteria.of_types([Review.name, Article.name]).bad.desc(:reported_on, :updated_on).size
    @good_count = @query_criteria.of_types([Review.name, Article.name]).good.desc(:reported_on, :updated_on).size

    @bad_items = @query_criteria.of_types([Review.name, Article.name]).bad.desc(:reported_on, :updated_on).page(params[:page]).per(ITEMS_PER_PAGE_FEW)
    @good_items = @query_criteria.of_types([Review.name, Article.name]).good.desc(:reported_on, :updated_on).page(params[:page]).per(ITEMS_PER_PAGE_FEW)
    @tips = @query_criteria.of_types([Tip.name]).desc(:reported_on, :updated_on).page(params[:page]).per(ITEMS_PER_PAGE_FEW)

    @bad_region_names = @bad_items.inject([]) {|memo, e| memo << e.city }.compact.uniq
  end

end