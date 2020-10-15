module ApplicationHelper

  def current_user
    @current_user ||= User.find_by(username: session[:username]) if session[:username]
  end

  def logged_in?
    !!current_user
  end
end
