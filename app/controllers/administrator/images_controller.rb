class Administrator::ImagesController < Administrator::BaseController

  def index
    @images = Image.all
  end
end
