class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :authenticate

  # POST /auth/authenticate
  def authenticate
    header = request.headers['Authorization']
    credentials = header.split(':')
    @user = User.find_by_username(credentials[0])
    if !@user.blank? && @user.authenticate(credentials[1]) && @user.has_access?
      token = JsonWebToken.encode(username: @user.username)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
