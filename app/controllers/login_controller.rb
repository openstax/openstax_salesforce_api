require 'openstax_accounts'

class LoginController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
    if signed_in?
      #hack until gem is updated
      #current_user.is_administrator = true
      puts 'current_user: ' + current_user.inspect
    end
  end

  def create
    #send then to accounts
    # when they return, call accounts api to is_administrator
    # if admin, forward to application list
    # Otherwise, display error
    #
    #authenticate_user!
    #puts 'current_user: ' + current_user.inspect
    # unless current_user&.is_administrator?
    #   flash.now[:notice] = 'You must be an admin to log in'
    #   render 'new'
    #   return
    # end
    #
    # if user.authenticate(params[:login][:password])
    #   session[:username] = user.username
    #   redirect_to users_path
    #   return
    # else
    #   flash[:notice] = 'username or password was not found'
    #   render 'new'
    #   return
    # end
  end

  def destroy
    session[:username] = nil
    flash[:notice] = 'You are logged out'
    redirect_to login_path

  end
end
