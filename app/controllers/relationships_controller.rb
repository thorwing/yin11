class RelationshipsController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }
  before_filter :find_followable

  def create
    if @followable
      relationship =  current_user.relationships.find_or_initialize_by( :target_type => params[:target_type], :target_id => params[:target_id] )
      if relationship.new_record?
        current_user.relationships << relationship
        current_user.save!
        @followable.add_follower!(current_user)
      end
    end
    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  def cancel
    if @followable
      current_user.relationships.destroy_all(:conditions => {:target_type => params[:target_type], :target_id => params[:target_id]})
      current_user.save!
      @followable.remove_follower!(current_user)
    end

    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  private

  def find_followable
    @followable = eval("#{params[:target_type]}.find(\"#{params[:target_id]}\")")
    @followable = nil if @followable == current_user
  end

end