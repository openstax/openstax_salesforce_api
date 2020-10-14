class LoginController < ApplicationController
  #before_action :require_admin

  def new

  end

  def create
    user = User.find_by(username: params[:login][:username])
    unless user&.is_admin?
      flash.now[:notice] = 'You must be an admin to log in'
      render 'new'
    end
    
    if user&.authenticate(params[:login][:password])
      session[:username] = user.username
      flash[:notice] = 'You are logged in'
      redirect_to login_path
    else
      flash.now[:notice] = 'username or password was not found'
      render 'new'
    end
  end

  def destroy
    session[:username] = nil
    flash[:notice] = 'You are logged out'
    redirect_to root_path

  end
end
