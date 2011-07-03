class Admin::ArticlesController < Admin::BaseController
  def index

  end

  def show

  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to(admin_reviews_url) }
      format.xml  { head :ok }
    end
  end
end