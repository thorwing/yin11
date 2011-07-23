class SearchController < ApplicationController
  before_filter :prepare_items
  def index
    #prepare parameters
    query = params[:query]
    if query.present?
      query_criteria = InfoItem.enabled

      #search by location
      region = City.first(:conditions => {:name => query})
      region = Province.first(:conditions => {:name => query}) unless region
      is_by_location = region.present?
      if is_by_location
        query_criteria = query_criteria.of_region(region.id)
      end

      #search by tags
      all_tags = get_all_tags
      query_tags = query.split(' ')
      tags = all_tags & query_tags
      is_by_tags = tags.size > 0
      if is_by_tags
        query_criteria = query_criteria.tagged_with(tags)
      end

      #search by title
      unless (is_by_location || is_by_tags)
        query_criteria = query_criteria.where(:title => /#{query}?}/)
      end

      process_items(query_criteria)
    end
  end

  def tag
    params[:tags]
  end

  def region
    params[:region_id]
  end

  protected
  def process_items(criteria)
    @bad_items = criteria.bad.desc(:reported_on, :updated_on).page(params[:page]).per(ITEMS_PER_PAGE_FEW)
    @good_items = criteria.good.desc(:reported_on, :updated_on).page(params[:page]).per(ITEMS_PER_PAGE_FEW)

    @bad_regions = @bad_items.inject([]) {|memo, e| memo | (e.region_ids || []).map{|id| get_region(id)} }.uniq.delete_if{|e| e.code == "ALL"}
  end

  def prepare_items
    @bad_items ||= []
    @good_items ||= []
    @bad_regions ||= []
    @good_count = 0
    @bad_count = 0
  end
end