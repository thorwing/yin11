class RelationshipsController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }
  before_filter :find_followable

  def create
    current_user.relationships << Relationship.new(:target_type => params[:target_type], :target_id => params[:target_id])
    @followable.add_follower!(current_user)

    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  def cancel
    current_user.relationships.destroy_all(:conditions => {:target_type => params[:target_type], :target_id => params[:target_id]})
    @followable.add_follower!(current_user)

    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  private

  def find_followable
    @followable = eval("#{params[:target_type]}.find(\"#{params[:target_id]}\")")
  end

end