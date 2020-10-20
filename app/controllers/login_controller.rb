class LoginController < ApplicationController

  def new

  end

  def create
    user = User.find_by(username: params[:login][:username])
    unless user&.is_admin?
      flash.now[:notice] = 'You must be an admin to log in'
      render 'new'
      return
    end
    
    if user.authenticate(params[:login][:password])
      session[:username] = user.username
      redirect_to users_path
      return
    else
      flash[:notice] = 'username or password was not found'
      render 'new'
      return
    end
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
