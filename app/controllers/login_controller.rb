require 'openstax_accounts'

class LoginController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
  end

  def create
  end

  def destroy
    session[:username] = nil
    flash[:notice] = 'You are logged out'
    redirect_to login_path

  end
end
