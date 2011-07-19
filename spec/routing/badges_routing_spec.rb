require "spec_helper"

describe BadgesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/badges" }.should route_to(:controller => "badges", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/badges/1" }.should route_to(:controller => "badges", :action => "show", :id => "1")
    end

  end
end
