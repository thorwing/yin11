require "spec_helper"

describe TagsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/tags" }.should route_to(:controller => "tags", :action => "index")
    end

  end
end
