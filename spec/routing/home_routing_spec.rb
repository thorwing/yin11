require "spec_helper"

describe HomeController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/" }.should route_to(:controller => "home", :action => "index")
    end

    it "recognizes and generates #more_items" do
      { :get => "/home/more_items" }.should route_to(:controller => "home", :action => "more_items")
    end

  end
end
