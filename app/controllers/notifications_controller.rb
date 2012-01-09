class NotificationsController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def index
    @modes = ["inbox", "outbox", "sys_msg"]
    if params[:mode].present?
     @current_mode = params[:mode]
    elsif session[:notification_mode].present?
     @current_mode = session[:notification_mode]
    else
      @current_mode = "sys_msg"
    end
    session[:notification_mode] = @current_mode
    page = params[:page].present? ? params[:page].to_i : 0
    case @current_mode
      when "inbox"
        @messages = []
      when "outbox"
        @messages = []
      when "sys_msg"
        if params[:read].present? && params[:read] == false
          @notifications = current_user.notifications.where(read: false).desc(:created_at)
        else
          @notifications = current_user.notifications.desc(:created_at)
        end
    end
  end

  def read
    @notification = current_user.notifications.find(params[:id])
    @notification.read = true
    @notification.save

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @notification_id = current_user.notifications.delete_all(conditions: { id: params[:id]})

    respond_to do |format|
      format.js
    end
  end



end