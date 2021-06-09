module SessionsHelper

  # Sign in the given user
  def sign_in(user)
    session[:user_id] = user.id
  end

  # Sign out the current user
  def sign_out
    @current_user = nil
    session[:user_id] = nil
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

  # Returns true if current user is allowed to modify resources owned by the given user
  def authorized?(user)
    return false unless signed_in?
    # For now, just check for equality
    current_user == user
  end

end
