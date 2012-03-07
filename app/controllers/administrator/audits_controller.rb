class Administrator::AuditsController < Administrator::BaseController
  def index
    if params[:url]
      @audits = Audit.where(url: params[:url])
      @product = Product.first(conditions:{refer_url: params[:url]})
      @product = Product.first(conditions:{normal_url: params[:url]}) unless @product
      @users = User.any_in(_id: @audits.map(&:user_id))
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @audit }
    end
  end
end