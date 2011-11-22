class Administrator::TagsController < Administrator::BaseController
  def index
    @tags = Tag.all
  end


end