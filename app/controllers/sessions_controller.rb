class SessionsController < ApplicationController
  skip_before_action :require_login

  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      # Log the user in and redirect
      sign_in user
      redirect_to :root, notice: "You have successfully signed in."
    else
      # Create an error message.
      flash.now[:alert] = "The username or password is incorrect."
      render 'new'
    end
  end

  # DELETE /logout
  def destroy
  end
end
