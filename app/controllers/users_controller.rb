class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    @user = User.find_by_username!(params[:username])
    render json: @user, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end


end
