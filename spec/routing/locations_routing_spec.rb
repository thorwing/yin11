require "spec_helper"

describe LocationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/locations/search" }.should route_to(:controller => "locations", :action => "search")
    end

    it "recognizes and generates #edit_current_city" do
      { :get => "/locations/edit_current_city" }.should route_to(:controller => "locations", :action => "edit_current_city")
    end

    it "recognizes and generates #update_current_city" do
      { :post => "/locations/update_current_city" }.should route_to(:controller => "locations", :action => "update_current_city")
    end

    it "recognizes and generates #show_nearby_items" do
      { :get => "/locations/show_nearby_items" }.should route_to(:controller => "locations", :action => "show_nearby_items")
    end

    it "recognizes and generates #regions" do
      { :get => "/locations/regions" }.should route_to(:controller => "locations", :action => "regions")
    end

    it "recognizes and generates #cities" do
      { :get => "/locations/cities" }.should route_to(:controller => "locations", :action => "cities")
    end

  end
end
