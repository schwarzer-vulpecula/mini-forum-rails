class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[ destroy ]
  before_action :require_permission, only: %i[ destroy ]

  # GET /notifications
  def index
    @notifications = current_user.notifications
  end

  # DELETE /notifications/1
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: "Notification was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    def require_permission
      unless @notification.user == current_user
        unauthorized_redirect_to :root
      end
    end
end
