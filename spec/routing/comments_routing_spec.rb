require "spec_helper"

describe CommentsController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/comments/new" }.should route_to(:controller => "comments", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/comments" }.should route_to(:controller => "comments", :action => "create")
    end

  end
end
