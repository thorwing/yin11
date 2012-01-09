class MessagesController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }
  before_filter :find_user

  def create
    @user.messages.create(from_id: current_user.id.to_s, to_id: @user.id.to_s, content: params[:content])
    current_user.messages.create(from_id: current_user.id.to_s, to_id: @user.id.to_s, content: params[:content])

    respond_to do |format|
        format.js
    end
  end

  protected

  def find_user
    @user = User.first(conditions: {id: params[:user_id]})
  end

end
