class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper

  before_action :require_login

  private
    def require_login
      unless signed_in?
        flash[:alert] = "You must be signed in to do that."
        redirect_to login_url
      end
    end
end
