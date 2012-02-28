class Administrator::UsersController < Administrator::BaseController
  before_filter() { |c| c.require_permission :administrator}

  def index
    @users = User.desc(:role).asc(:created_at)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.role = params[:new_role] if params[:new_role].present?

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to([:administrator, @user], :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end