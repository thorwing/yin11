require "spec_helper"

describe UsersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sign_up" }.should route_to(:controller => "users", :action => "new")
    end

    it "recognizes and generates #new" do
      { :get => "/users/new" }.should route_to(:controller => "users", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/users/1" }.should route_to(:controller => "users", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/users/1/edit" }.should route_to(:controller => "users", :action => "edit", :id => "1")
     end

    it "recognizes and generates #update" do
      { :put => "/users/1" }.should route_to(:controller => "users", :action => "update", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/users" }.should route_to(:controller => "users", :action => "create")
    end

    it "recognizes and generates #block" do
      { :put => "/users/1/block" }.should route_to(:controller => "users", :action => "block", :id => "1")
    end

    it "recognizes and generates #unlock" do
      { :put => "/users/1/unlock" }.should route_to(:controller => "users", :action => "unlock", :id => "1")
    end

    it "recognizes and generates #check_email" do
      { :get => "/users/check_email" }.should route_to(:controller => "users", :action => "check_email")
    end

    it "recognizes and generates #email_verify" do
      { :get => "/users/1/verify_email" }.should route_to(:controller => "users", :action => "verify_email", :id => "1")
    end

  end
end
