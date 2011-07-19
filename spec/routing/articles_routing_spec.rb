require "spec_helper"

describe ArticlesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/articles" }.should route_to(:controller => "articles", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/articles/1" }.should route_to(:controller => "articles", :action => "show", :id => "1")
    end

  end
end
