require "spec_helper"

describe SearchController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/search" }.should route_to(:controller => "search", :action => "index")
    end

     it "recognizes and generates #tag" do
      { :get => "/search/tag" }.should route_to(:controller => "search", :action => "tag")
     end

     it "recognizes and generates #region" do
      { :get => "/search/region" }.should route_to(:controller => "search", :action => "region")
    end

  end
end