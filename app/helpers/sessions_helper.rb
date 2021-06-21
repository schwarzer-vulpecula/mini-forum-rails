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

  # Saves the user stored in sessions in @current_user
  # Sign the user out immediately if the user is banned
  # Then return it
  def current_user
    @current_user = User.find_by(id: session[:user_id]) if @current_user.nil?
    sign_out if !@current_user.nil? && @current_user.banned
    @current_user
  end

  # Returns true if current session is storing a user
  def signed_in?
    !current_user.nil?
  end

  # Returns true if current user is higher rank than the object's owner, or current user is the same user as the object's owner
  def higher_rank?(object)
    return false unless signed_in?
    if object.is_a?(User)
      current_user == object || current_user.rank_before_type_cast > object.rank_before_type_cast
    else
      current_user == object.user || current_user.rank_before_type_cast > object.user.rank_before_type_cast
    end
  end

  # Returns true if current user should be allowed to modify the username of the given user
  def allow_username_change?(user)
    return true if user.new_record?
    return false unless signed_in?
    current_user.rank == 'administrator'
  end

  # Similar to the above, but for passwords
  def allow_password_change?(user)
    return true if user.new_record?
    return false unless signed_in?
    current_user == user
  end

  # Returns true if current user should be allowed to destroy the given user
  def allow_user_destroy?(user)
    # For now, nobody can destroy users as it is rather destructive
    return false
  end

  # Returns true if current user can ban the given user
  def allow_user_ban?(user)
    return false unless signed_in?
    return false if current_user == user # Cannot self ban
    current_user.staff? && current_user.rank_before_type_cast > user.rank_before_type_cast
  end

end
