require 'openstax_accounts'

class LoginController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
    if signed_in? && !current_user.is_administrator?
      redirect_to error_path
    end
  end

  def create
  end

  def destroy
    session[:username] = nil
    redirect_to login_path

  end
end
