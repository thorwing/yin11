class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end

  def new
    if params[:group_id].present?
      @group = Group.find(params[:group_id])
      @post = @group.posts.new
    else
      redirect_to groups_url, :alert => t("alerts.no_group_specified")
    end
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to @post.group, :notice => t("notices.post_created")
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to posts_url, :notice  => "Successfully updated post."
    else
      render :action => 'edit'
    end
  end
end
