require "spec_helper"

describe DesiresController do
  describe "routing" do

    it "routes to #index" do
      get("/desires").should route_to("desires#index")
    end

    it "routes to #new" do
      get("/desires/new").should route_to("desires#new")
    end

    it "routes to #show" do
      get("/desires/1").should route_to("desires#show", :id => "1")
    end

    it "routes to #edit" do
      get("/desires/1/edit").should route_to("desires#edit", :id => "1")
    end

    it "routes to #create" do
      post("/desires").should route_to("desires#create")
    end

    it "routes to #update" do
      put("/desires/1").should route_to("desires#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/desires/1").should route_to("desires#destroy", :id => "1")
    end

  end
end
