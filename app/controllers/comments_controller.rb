class CommentsController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }
  #before_filter(:only => [:toggle, :delete]) {|c| @comment.present? && c.the_author_himself(@comment, true, true)}
  before_filter :find_item

  #used for un-javascript
  def new
    if params[:parent_id].present?
      @parent = @item.comments.find(params[:parent_id])
      @comment = @parent.children.build(:content => params[:content])
    else
      @comment = Comment.new(:content => params[:content])
    end

    respond_to do |format|
      format.html  {render "new", :layout => "dialog"}
    end
  end

  def create
    @over_limit = Cooler.rapid_commenter?(current_user, @item)

    unless @over_limit
      if params[:parent_id].present?
        @parent = @item.comments.find(params[:parent_id])
        @comment = @parent.children.build(:content => params[:content], :user => current_user)
        @item.comments << @comment
        #parent_comment.children.create(:content => params[:content], :user_id => current_user.id)
        #item.comments << Comment.create(:content => params[:content], :user_id => current_user.id, :parent_id => parent_comment.id)
      else
        @comment = @item.comments.create(:content => params[:content], :user => current_user)
      end

      if [Desire.name, Album.name, Recipe.name].include? @item.class.name
        NotificationsManager.generate_for_comment(@item.author, current_user, @item, @comment)
        NotificationsManager.generate_for_comment(@parent.user, current_user, @item, @comment, true) if @parent
      end
    end

    respond_to do |format|
      format.html {redirect_to @item}
      format.xml {head :ok}
      format.js {render :content_type => 'text/javascript'}
    end
  end

  def toggle
    @comment = @item.comments.find(params[:id])
    @comment.enabled = !@comment.enabled
    @comment.save

    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  def delete
    @comment = @item.comments.find(params[:id])
    @comment.delete

    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  protected

  def find_item
    @item = find_item_by_type_and_id(params[:item_type], params[:item_id])
  end

end