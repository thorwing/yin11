class BadgesController < ApplicationController
  before_filter(:except => [:index, :show]) { |c| c.require_permission :administrator }

  # GET /badges
  # GET /badges.xml
  def index
    @badges = Badge.enabled.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @badges }
    end
  end

  # GET /badges/1
  # GET /badges/1.xml
  def show
    @badge = Badge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @badge }
    end
  end

end
