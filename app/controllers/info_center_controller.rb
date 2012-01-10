class InfoCenterController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

  def index
    @modes = ["inbox", "outbox", "sys_msg", "writing"]
    if params[:mode].present?
     @current_mode = params[:mode]
    elsif session[:notification_mode].present?
     @current_mode = session[:notification_mode]
    else
      @current_mode = "inbox"
    end
    session[:notification_mode] = @current_mode

    if params[:read].present? && params[:read] == "false"
      @notifications = current_user.notifications.where(read: false).desc(:created_at)
    else
      @notifications = current_user.notifications.desc(:created_at)
    end

    @incoming_messages = current_user.messages.desc(:created_at).group_by{|m| [m.from_id, m.to_id].sort()}.reject{|key, value| value.select{|m| m.to_id == current_user.id.to_s }.empty? }
    @outgoing_messages = current_user.messages.where(from_id: current_user.id.to_s).desc(:created_at)
  end

end