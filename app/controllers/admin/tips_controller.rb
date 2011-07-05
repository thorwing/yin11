class Admin::TipsController < Admin::BaseController

  def index
    @tips = Tip.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tips }
      format.json { render :json => Tip.all.map { |t| {:id => t.id, :name => t.title} } }
    end
  end

  def show
    @tip = Tip.find(params[:id])
  end

  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy

    respond_to do |format|
      format.html { redirect_to(admin_tips_url) }
      format.xml  { head :ok }
    end
  end
end