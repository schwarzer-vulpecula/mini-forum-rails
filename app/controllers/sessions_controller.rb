class SessionsController < ApplicationController

  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      # Log the user in and redirect
      redirect_to :root
    else
      # Create an error message.
      render 'new'
    end
  end

  # DELETE /logout
  def destroy
  end
end
