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

    criteria = current_user.notifications
    if params[:read].present? && params[:read] == "false"
      criteria = criteria.where(read: false)
    end
    @notifications = criteria.desc(:created_at).to_a.uniq{|n| n.identity}

    #mark all as read
    if @current_mode == "sys_msg"
      current_user.notifications.where(read: false).update_all(read: true)
    end

    @incoming_messages = current_user.messages.desc(:created_at).group_by{|m| [m.from_id, m.to_id].sort()}.reject{|key, value| value.select{|m| m.to_id == current_user.id.to_s }.empty? }
    @outgoing_messages = current_user.messages.where(from_id: current_user.id.to_s).desc(:created_at)
  end

end