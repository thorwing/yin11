require "spec_helper"

describe VendorsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/vendors" }.should route_to(:controller => "vendors", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/vendors/new" }.should route_to(:controller => "vendors", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/vendors/1" }.should route_to(:controller => "vendors", :action => "show", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/vendors" }.should route_to(:controller => "vendors", :action => "create")
    end

    it "recognizes and generates #search" do
      { :post => "/vendors/search" }.should route_to(:controller => "vendors", :action => "search")
    end

  end
end
