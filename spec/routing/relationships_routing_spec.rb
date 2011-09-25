require "spec_helper"

describe GroupsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/relationships" }.should route_to(:controller => "relationships", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/relationships/1" }.should route_to(:controller => "relationships", :action => "show", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/relationships" }.should route_to(:controller => "relationships", :action => "create")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/relationships/1" }.should route_to(:controller => "relationships", :action => "destroy", :id => "1")
    end

  end
end
