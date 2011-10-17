class Administrator::BadgesController < Administrator::BaseController
  def index
    @badges = Badge.enabled

    @disabled_badges = Badge.disabled

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @badges }
    end
  end
end
