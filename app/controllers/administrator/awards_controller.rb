class Administrator::AwardsController < Administrator::BaseController
  before_filter :preload
  before_filter() { |c| c.require_permission :administrator}

  def index
    @awards = Award.all
  end

  def show

  end

  def edit
  end

  def new
    @award = Award.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @award = Award.new(params[:award])
    @award.create_image(picture: params[:image])


    respond_to do |format|
      if @award.save
        format.html { redirect_to [:administrator, @award], notice: 'Award was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update

    respond_to do |format|
      if @award.update_attributes(params[:award])
        format.html { redirect_to [:administrator, @award], notice: 'Award was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @award.destroy

    respond_to do |format|
      format.html { redirect_to administrator_awards_url }
    end
  end

  def preload
    @award = Award.find(params[:id]) if params[:id].present?
  end

end
