class Administrator::AuditsController < Administrator::BaseController
  def index
    #Audit.delete_all
    @audit = Audit.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @audit }
    end
  end
end