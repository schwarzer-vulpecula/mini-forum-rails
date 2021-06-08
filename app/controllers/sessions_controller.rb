class SessionsController < ApplicationController
  skip_before_action :require_login
  before_action :require_not_login, except: :destroy

  # GET /login
  def new
    # Set url to be redirected to, unless it is the login url
    unless request.referer == login_url
      session[:referer] = request.referer
    end
  end

  # POST /login
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      # Log the user in and redirect
      sign_in user
      flash[:notice] = "You have successfully signed in."
      if session[:referer] != nil
        redirect_to session[:referer]
        session[:referer] = nil
      else
        redirect_to :root
      end
    else
      # Create an error message.
      flash.now[:alert] = "The username or password is incorrect."
      render 'new'
    end
  end

  # DELETE /logout
  def destroy
    sign_out
    redirect_back fallback_location: :root, notice: "You have successfully signed out."
  end

  private
    def require_not_login
      if signed_in?
        flash[:alert] = "You are already signed in."
        redirect_back fallback_location: :root
      end
    end

end
