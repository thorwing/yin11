require "spec_helper"

describe Administrator::UsersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/administrator/users" }.should route_to(:controller => "administrator/users", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/administrator/users/1" }.should route_to(:controller => "administrator/users", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/administrator/users/1/edit" }.should route_to(:controller => "administrator/users", :action => "edit", :id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/administrator/users/1" }.should route_to(:controller => "administrator/users", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/administrator/users/1" }.should route_to(:controller => "administrator/users", :action => "destroy", :id => "1")
    end

  end
end
