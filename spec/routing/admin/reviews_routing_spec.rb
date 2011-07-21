require "spec_helper"

describe Admin::ReviewsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/reviews" }.should route_to(:controller => "admin/reviews", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/reviews/1" }.should route_to(:controller => "admin/reviews", :action => "show", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/reviews/1" }.should route_to(:controller => "admin/reviews", :action => "destroy", :id => "1")
    end

  end
end
