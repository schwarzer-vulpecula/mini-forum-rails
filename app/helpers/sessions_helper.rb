module SessionsHelper

  # Sign in the given user
  def sign_in(user)
    session[:user_id] = user.id
  end

  # Saves the user stored in sessions in @current_user, and returns it
  # If @current_user has something, simply return it
  def current_user
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
    end
  end

  # Returns true if current session is storing a user
  def signed_in?
    !current_user.nil?
  end

end
