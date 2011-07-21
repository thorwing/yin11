require "spec_helper"

describe RecommendationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/recommendations" }.should route_to(:controller => "recommendations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/recommendations/new" }.should route_to(:controller => "recommendations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/recommendations/1" }.should route_to(:controller => "recommendations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/recommendations/1/edit" }.should route_to(:controller => "recommendations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/recommendations" }.should route_to(:controller => "recommendations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/recommendations/1" }.should route_to(:controller => "recommendations", :action => "update", :id => "1")
    end

  end
end
