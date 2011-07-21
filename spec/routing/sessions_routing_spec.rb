require "spec_helper"

describe SessionsController do
  describe "routing" do

    it "recognizes and generates #login" do
      { :get => "/login" }.should route_to(:controller => "sessions", :action => "new")
    end

    it "recognizes and generates #logout" do
      { :get => "/logout" }.should route_to(:controller => "sessions", :action => "destroy")
    end

  end
end
