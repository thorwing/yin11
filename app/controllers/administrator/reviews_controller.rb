class Administrator::ReviewsController < Administrator::BaseController
  def index

  end

  def show

  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to(administrator_reviews_url) }
      format.xml  { head :ok }
    end
  end
end