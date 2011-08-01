class TagsController < ApplicationController
  def index
    query = params[:q]
    if query.present?
      @tags = CacheManager.all_tags_with_weight.select {|t| t[0] =~ /#{query}?/}
    else
      @tags = CacheManager.all_tags_with_weight
    end

    #if it's a new tag'
    new_tag = query[0..(MAX_TAG_CHARS - 1)]
    is_new_tag = !(@tags.map{|t| t[0]}.include?(new_tag))

    @tags =  @tags.map { |t| {:id => t[0], :name => "#{t[0]} (#{t[1]})"} }

    #insert new tag
    @tags.insert(0, {:id => new_tag, :name => "#{new_tag} (#{t("tags.new_tag")})" }) if is_new_tag

    respond_to do |format|
      format.json { render :json => @tags }
    end
  end

end