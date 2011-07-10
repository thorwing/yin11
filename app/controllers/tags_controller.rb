class TagsController < ApplicationController
  def index
    query = params[:q]
    if query.present?
      @tags = get_hot_tags.select {|t| t =~ /#{query}?/}
    else
      @tags = get_all_tags
    end

    @tags.insert(0, query) unless @tags.include?(query)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @tags }
      format.json { render :json => @tags.map { |t| {:id => t, :name => t } } }
    end
  end

end