require "spec_helper"

describe TipsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/tips" }.should route_to(:controller => "tips", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/tips/new" }.should route_to(:controller => "tips", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/tips/1" }.should route_to(:controller => "tips", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/tips/1/edit" }.should route_to(:controller => "tips", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/tips" }.should route_to(:controller => "tips", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/tips/1" }.should route_to(:controller => "tips", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/tips/1" }.should route_to(:controller => "tips", :action => "destroy", :id => "1")
    end

    it "recognizes and generates #search" do
      { :post => "/tips/search" }.should route_to(:controller => "tips", :action => "search")
    end

  end
end
