class LoginController < ApplicationController

  def new

  end

  def create
    user = User.find_by(username: params[:login][:username])
    puts '###user: ' + user.authenticate(params[:login][:password]).inspect
    unless user&.is_admin?
      flash.now[:notice] = 'You must be an admin to log in'
      render 'new'
    end
    
    if user.authenticate(params[:login][:password])
      session[:username] = user.username
      flash[:notice] = 'You are logged in'
      puts '###user: user found'
    else
      puts '###user: user not found'
      flash[:notice] = 'username or password was not found'
    end
    redirect_to login_path
  end

  def destroy
    session[:username] = nil
    flash[:notice] = 'You are logged out'
    redirect_to login_path

  end

  private

  def login_params
    params.require(:login).permit(:username, :password)
  end
end
