class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :require_login

  # Redirect to given location with a flash telling the user that they are not authorized
  def unauthorized_redirect_to(location)
    flash[:alert] = "You are not authorized to do that."
    redirect_to location
  end

  private
    def require_login
      unless signed_in?
        flash[:alert] = "You must be signed in to do that."
        redirect_to login_url
      end
    end
end
