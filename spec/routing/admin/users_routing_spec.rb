require "spec_helper"

describe Admin::UsersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/users" }.should route_to(:controller => "admin/users", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/users/1" }.should route_to(:controller => "admin/users", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/users/1/edit" }.should route_to(:controller => "admin/users", :action => "edit", :id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/users/1" }.should route_to(:controller => "admin/users", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/users/1" }.should route_to(:controller => "admin/users", :action => "destroy", :id => "1")
    end

  end
end