require "spec_helper"

describe Administrator::VendorsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/administrator/vendors" }.should route_to(:controller => "administrator/vendors", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/administrator/vendors/new" }.should route_to(:controller => "administrator/vendors", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/administrator/vendors/1" }.should route_to(:controller => "administrator/vendors", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/administrator/vendors/1/edit" }.should route_to(:controller => "administrator/vendors", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/administrator/vendors" }.should route_to(:controller => "administrator/vendors", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/administrator/vendors/1" }.should route_to(:controller => "administrator/vendors", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/administrator/vendors/1" }.should route_to(:controller => "administrator/vendors", :action => "destroy", :id => "1")
    end

  end
end
