require "spec_helper"

describe CitiesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/cities" }.should route_to(:controller => "cities", :action => "index")
    end

  end
end
