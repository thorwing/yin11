require "spec_helper"

describe Administrator::ReviewsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/administrator/reviews" }.should route_to(:controller => "administrator/reviews", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/administrator/reviews/1" }.should route_to(:controller => "administrator/reviews", :action => "show", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/administrator/reviews/1" }.should route_to(:controller => "administrator/reviews", :action => "destroy", :id => "1")
    end

  end
end
