require "spec_helper"

#                         toggle_comment PUT    /comments/:id/toggle(.:format)             {:action=>"toggle", :controller=>"comments"}
#                         comments GET    /comments(.:format)                        {:action=>"index", :controller=>"comments"}
#                                  POST   /comments(.:format)                        {:action=>"create", :controller=>"comments"}
#                      new_comment GET    /comments/new(.:format)                    {:action=>"new", :controller=>"comments"}
#                     edit_comment GET    /comments/:id/edit(.:format)               {:action=>"edit", :controller=>"comments"}
#                          comment GET    /comments/:id(.:format)                    {:action=>"show", :controller=>"comments"}
#                                  PUT    /comments/:id(.:format)                    {:action=>"update", :controller=>"comments"}
#                                  DELETE /comments/:id(.:format)                    {:action=>"destroy", :controller=>"comments"}


describe CommentsController do
  describe "routing" do

    it "routes to #toggle" do
      { :put => "/comments/1/toggle" }.should route_to(:controller => "comments", :action => "toggle", :id => "1")
    end

    it "routes to #index" do
      { :get => "/comments" }.should route_to(:controller => "comments", :action => "index")
    end

    it "routes to #create" do
      { :post => "/comments" }.should route_to(:controller => "comments", :action => "create")
    end

    it "routes to #new" do
      { :get => "/comments/new" }.should route_to(:controller => "comments", :action => "new")
    end

    it "routes to #edit" do
      { :get => "/comments/1/edit" }.should route_to(:controller => "comments", :action => "edit", :id => "1")
    end

    it "routes to #show" do
      { :get => "/comments/1" }.should route_to(:controller => "comments", :action => "show", :id => "1")
    end

    it "routes to #update" do
      { :put => "/comments/1" }.should route_to(:controller => "comments", :action => "update", :id => "1")
    end

    it "routes to #destroy" do
      { :delete => "/comments/1" }.should route_to(:controller => "comments", :action => "destroy", :id => "1")
    end


  end
end
