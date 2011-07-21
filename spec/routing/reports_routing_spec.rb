require "spec_helper"

describe ReportsController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/reports/new" }.should route_to(:controller => "reports", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/reports" }.should route_to(:controller => "reports", :action => "create")
    end

  end
end
