require "spec_helper"

describe Administrator::ArticlesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/administrator/articles" }.should route_to(:controller => "administrator/articles", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/administrator/articles/new" }.should route_to(:controller => "administrator/articles", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/administrator/articles/1" }.should route_to(:controller => "administrator/articles", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/administrator/articles/1/edit" }.should route_to(:controller => "administrator/articles", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/administrator/articles" }.should route_to(:controller => "administrator/articles", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/administrator/articles/1" }.should route_to(:controller => "administrator/articles", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/administrator/articles/1" }.should route_to(:controller => "administrator/articles", :action => "destroy", :id => "1")
    end

  end
end
