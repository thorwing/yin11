require "spec_helper"

describe Admin::ArticlesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/articles" }.should route_to(:controller => "admin/articles", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/articles/new" }.should route_to(:controller => "admin/articles", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/articles/1" }.should route_to(:controller => "admin/articles", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/articles/1/edit" }.should route_to(:controller => "admin/articles", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/articles" }.should route_to(:controller => "admin/articles", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/articles/1" }.should route_to(:controller => "admin/articles", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/articles/1" }.should route_to(:controller => "admin/articles", :action => "destroy", :id => "1")
    end

  end
end
