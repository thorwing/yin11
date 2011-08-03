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

    it "recognizes and generates #collect" do
      { :put => "/tips/1/collect" }.should route_to(:controller => "tips", :action => "collect", :id => "1")
    end

    it "recognizes and generates #revisions" do
      { :get => "/tips/1/revisions" }.should route_to(:controller => "tips", :action => "revisions", :id => "1")
    end

    it "recognizes and generates #roll_back" do
      { :put => "/tips/1/roll_back" }.should route_to(:controller => "tips", :action => "roll_back", :id => "1")
    end
  end
end
