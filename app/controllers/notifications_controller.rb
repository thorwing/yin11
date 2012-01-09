class NotificationsController < ApplicationController
  before_filter { |c| c.require_permission :normal_user }

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