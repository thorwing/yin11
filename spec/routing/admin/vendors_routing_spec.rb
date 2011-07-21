require "spec_helper"

describe Admin::VendorsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/vendors" }.should route_to(:controller => "admin/vendors", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/vendors/new" }.should route_to(:controller => "admin/vendors", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/vendors/1" }.should route_to(:controller => "admin/vendors", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/vendors/1/edit" }.should route_to(:controller => "admin/vendors", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/vendors" }.should route_to(:controller => "admin/vendors", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/vendors/1" }.should route_to(:controller => "admin/vendors", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/vendors/1" }.should route_to(:controller => "admin/vendors", :action => "destroy", :id => "1")
    end

  end
end
