class CommentsController < ApplicationController
   before_filter { |c| c.require_permission :normal_user }

  def new
    @item = ItemFinder.get_item(params[:item_type], params[:item_id])
    if params[:parent_comment_id].present?
      @parent_comment = @item.comments.find(params[:parent_comment_id])
      @comment = @parent_comment.children.build(:content => params[:content])
    else
      @comment = Comment.new(:content => params[:content])
    end
  end

  def create
    @item = ItemFinder.get_item(params[:item_type], params[:item_id])
    @allowed = true
    comments = @item.comments.where(:user_id => current_user.id).desc(:created_at).to_a
    if comments.size > 0 && comments.first.created_at > GlobalConstants::COMMENTS_INTERVAL.minutes.ago
      @allowed = false
    end

    if @allowed
      if params[:parent_comment_id].present?
        @parent_comment = @item.comments.find(params[:parent_comment_id])
        @new_comment = @parent_comment.children.build(:content => params[:content], :user_id => current_user.id)
        #parent_comment.children.create(:content => params[:content], :user_id => current_user.id)
        @item.comments << @new_comment
        #item.comments << Comment.create(:content => params[:content], :user_id => current_user.id, :parent_id => parent_comment.id)
      else
        @item.comments ||= []
        @new_comment = Comment.new(:content => params[:content], :user_id => current_user.id)
        @item.comments << @new_comment
        @item.save
      end
    end

    respond_to do |format|
        format.html {redirect_to @item}
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
    end

  end
end