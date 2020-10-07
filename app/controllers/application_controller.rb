class ApplicationController < ActionController::API

  def authorize_request
    auth = request.headers['Authorization']
    header = auth.split(' ').last if auth
    begin
      @decoded = JsonWebToken.decode(header)
      @app_user = User.find_by_username(@decoded['username'])
      if @app_user.blank? || !@app_user.has_access?
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to login_path
    end
  end
end
