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
      if user.banned
        flash.now[:alert] = "Sorry, this user is currently banned."
        render 'new'
        return
      end
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
    if signed_in?
      sign_out
      redirect_to :root, notice: "You have successfully signed out."
    else
      redirect_to :root, alert: "You have already signed out."
    end
  end

  private
    def require_not_login
      if signed_in?
        redirect_back fallback_location: :root, alert: "You are already signed in."
      end
    end

end
