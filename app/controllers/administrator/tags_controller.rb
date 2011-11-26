class Administrator::TagsController < Administrator::BaseController
  def index
    @tags = Tag.desc(:items)
  end


end