class CommentsController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  #used for un-javascript
  def new
    @item = ItemFinder.get_item(params[:item_type], params[:item_id])
    if params[:parent_id].present?
      @parent = @item.comments.find(params[:parent_id])
      @comment = @parent.children.build(:content => params[:content])
    else
      @comment = Comment.new(:content => params[:content])
    end
  end

  def create
    @item = ItemFinder.get_item(params[:item_type], params[:item_id])
    comments = @item.comments.where(:user_id => current_user.id).desc(:created_at).to_a

    @over_limit = (comments.first && comments.first.created_at > COMMENTS_INTERVAL.minutes.ago)
    unless @over_limit
      if params[:parent_id].present?
        @parent = @item.comments.find(params[:parent_id])
        @comment = @parent.children.build(:content => params[:content], :user_id => current_user.id)
        @item.comments << @comment
        #parent_comment.children.create(:content => params[:content], :user_id => current_user.id)
        #item.comments << Comment.create(:content => params[:content], :user_id => current_user.id, :parent_id => parent_comment.id)
      else
        @comment = @item.comments.create(:content => params[:content], :user_id => current_user.id)
      end
    end

    respond_to do |format|
        format.html {redirect_to @item}
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
    end

  end
end