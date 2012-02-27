class Administrator::InvitationsController < Administrator::BaseController
	def index
		@invitations = Invitation.desc(:used)
	end

  def new
    @invitation = Invitation.new( :code =>  SecureRandom.hex(10))
  end

	def create
    @invitation = Invitation.new(params[:invitation])

    if @invitation.save
      respond_to do |format|
        format.html { redirect_to administrator_invitations_path }
      end
    end
  end

  def edit
    @invitation = Invitation.find(params[:id])
  end

  def update
    @invitation = Invitation.find(params[:id])

    respond_to do |format|
      if @invitation.update_attributes(params[:invitation])
        format.html { redirect_to administrator_invitations_path }
      else
        format.html { render action: "edit" }
      end
    end
  end

end
