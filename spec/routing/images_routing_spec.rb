require "spec_helper"

describe ImagesController do
  describe "routing" do
    it "recognizes and generates #create" do
      { :post => "/images" }.should route_to(:controller => "images", :action => "create")
    end

  end
end
