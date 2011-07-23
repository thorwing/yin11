class TagsController < ApplicationController
  def index
    query = params[:q]
    if query.present?
      @tags = get_hot_tags.select {|t| t =~ /#{query}?/}
    else
      @tags = get_all_tags
    end

    new_tag = query[0..(MAX_TAG_CHARS - 1)]
    @tags.insert(0, new_tag) unless @tags.include?(new_tag)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @tags }
      format.json { render :json => @tags.map { |t| {:id => t, :name => t } } }
    end
  end

end