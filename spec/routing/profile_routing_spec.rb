require "spec_helper"

describe ProfileController do
  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/profile/1" }.should route_to(:controller => "profile", :action => "show", :id => "1" )
    end

    it "recognizes and generates #edit" do
      { :get => "/profile/1/edit" }.should route_to(:controller => "profile", :action => "edit", :id => "1" )
    end

    it "recognizes and generates #update" do
      { :put => "/profile/1" }.should route_to(:controller => "profile", :action => "update", :id => "1" )
    end

    it "recognizes and generates #new_watched_location" do
      { :get => "/profile/new_watched_location" }.should route_to(:controller => "profile", :action => "new_watched_location")
    end

    it "recognizes and generates #create_watched_location" do
      { :post => "/profile/create_watched_location" }.should route_to(:controller => "profile", :action => "create_watched_location")
    end

    it "recognizes and generates #delete_watched_location" do
      { :put => "/profile/delete_watched_location" }.should route_to(:controller => "profile", :action => "delete_watched_location")
    end

     it "recognizes and generates #delete_watched_tag" do
      { :put => "/profile/delete_watched_tag" }.should route_to(:controller => "profile", :action => "delete_watched_tag")
    end

    it "recognizes and generates #watch_tags" do
      { :post => "/profile/watch_tags" }.should route_to(:controller => "profile", :action => "watch_tags")
    end

    it "recognizes and generates #toggle" do
      { :put => "/profile/toggle" }.should route_to(:controller => "profile", :action => "toggle")
    end
  end
end
