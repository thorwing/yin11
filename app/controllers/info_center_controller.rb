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

    unread_notification_ids = current_user.notifications.where(read: false).only(:id).map(&:id)
    #mark all as read
    current_user.notifications.where(read: false).update_all(read: true)
    @notifications = current_user.notifications.desc(:created_at).to_a.uniq{|n| n.identity}
    @notifications.each {|n| n.read = false if unread_notification_ids.include?(n.id)}

    @incoming_messages = current_user.messages.desc(:created_at).group_by{|m| [m.from_id, m.to_id].sort()}.reject{|key, value| value.select{|m| m.to_id == current_user.id.to_s }.empty? }
    @outgoing_messages = current_user.messages.where(from_id: current_user.id.to_s).desc(:created_at)
  end

end