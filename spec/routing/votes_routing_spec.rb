require "spec_helper"

describe VotesController do
  describe "routing" do

    it "recognizes and generates #create" do
      { :post => "/votes" }.should route_to(:controller => "votes", :action => "create")
    end

  end
end
