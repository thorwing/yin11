require "spec_helper"

describe CommentsController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/comments/new" }.should route_to(:controller => "comments", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/comments" }.should route_to(:controller => "comments", :action => "create")
    end

    it "recognizes and generates #toggle" do
      { :put => "/comments/1/toggle" }.should route_to(:controller => "comments", :action => "toggle", :id => "1")
    end

  end
end
