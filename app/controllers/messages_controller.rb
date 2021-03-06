class MessagesController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }
  before_filter :find_user

  def create
  if @user
    @message = @user.messages.create(from_id: current_user.id.to_s, to_id: @user.id.to_s, content: params[:content])
    current_user.messages.create(from_id: current_user.id.to_s, to_id: @user.id.to_s, content: params[:content])
  end

  respond_to do |format|
    if @message
      format.html { redirect_to "/info_center?mode=outbox", notice: t("notices.message_sent") }
      format.js
    else
      format.html { redirect_to :back, notice: t("alerts.invalid_message") }
      format.js
    end
  end

  end

  def show
    message = current_user.messages.find(params[:id])
    @to = message.to
    @messages = current_user.messages.any_in(from_id: [message.from_id, message.to_id])
    @messages.select{|m| !m.read}.each do |message|
      message.read = true
      message.save
    end
  end

  protected

  def find_user
    @user = User.first(conditions: {id: params[:user_id]})
  end

end
