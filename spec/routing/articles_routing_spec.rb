require "spec_helper"

                     #    articles GET    /articles(.:format)                        {:action=>"index", :controller=>"articles"}
                     #             POST   /articles(.:format)                        {:action=>"create", :controller=>"articles"}
                     # new_article GET    /articles/new(.:format)                    {:action=>"new", :controller=>"articles"}
                     #edit_article GET    /articles/:id/edit(.:format)               {:action=>"edit", :controller=>"articles"}
                     #     article GET    /articles/:id(.:format)                    {:action=>"show", :controller=>"articles"}
                     #             PUT    /articles/:id(.:format)                    {:action=>"update", :controller=>"articles"}
                     #             DELETE /articles/:id(.:format)                    {:action=>"destroy", :controller=>"articles"}



describe ArticlesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/articles" }.should route_to( "articles#index")
    end

    it "routes to #create" do
      { :post => "/articles" }.should route_to( "articles#create")
    end

    it "routes to #new" do
      { :get => "/articles/new" }.should route_to( "articles#new")
    end

    it "routes to #edit" do
      { :get => "/articles/1/edit" }.should route_to( "articles#edit", :id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "/articles/1" }.should route_to(:controller => "articles", :action => "show", :id => "1")
    end

    it "routes to #update" do
      { :put => "/articles/1" }.should route_to( "articles#update", :id => "1")
    end

    it "routes to #destroy" do
      { :delete => "/articles/1" }.should route_to( "articles#destroy", :id => "1")
    end

  end
end
