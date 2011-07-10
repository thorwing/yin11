require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Post.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Post.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(posts_url)
  end

  it "edit action should render edit template" do
    get :edit, :id => Post.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Post.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Post.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Post.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Post.first
    response.should redirect_to(posts_url)
  end
end
