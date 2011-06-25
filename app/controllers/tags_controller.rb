class TagsController < ApplicationController
  def index
    if params[:q]
      @tags = InfoItem.tagged_like_regex /#{params[:q]}?/
    else
      @tags = InfoItem.tags
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @tags }
      format.json { render :json => @tags.map { |t| {:id => t, :name => t } } }
    end
  end

end