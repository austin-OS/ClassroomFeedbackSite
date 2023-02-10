module SessionsHelper
  # Logs in a user, creating a session
  def login(user)
    session[:user_id] = user.id
  end

  # Logs a user out, deleting the session
  def logout
    reset_session
    @current_user = nil
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # added helper for current_user method
  # Returns true if the given user is the current user.
  def current_user?(user)
    user && user == current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
end
