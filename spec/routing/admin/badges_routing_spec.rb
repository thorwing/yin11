require "spec_helper"

describe Administrator::BadgesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/administrator/badges" }.should route_to(:controller => "administrator/badges", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/administrator/badges/new" }.should route_to(:controller => "administrator/badges", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/administrator/badges/1" }.should route_to(:controller => "administrator/badges", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/administrator/badges/1/edit" }.should route_to(:controller => "administrator/badges", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/administrator/badges" }.should route_to(:controller => "administrator/badges", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/administrator/badges/1" }.should route_to(:controller => "administrator/badges", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/administrator/badges/1" }.should route_to(:controller => "administrator/badges", :action => "destroy", :id => "1")
    end

  end
end
