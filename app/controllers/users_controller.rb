class UsersController < ApplicationController
  before_action :require_user, except: :create

  # GET /users
  def index
    @users = User.all
    #render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    @user = User.find_by_username!(params[:username])
    render json: @user, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def create
    @user = User.new(user_params)

    #make first user the admin by default
    # if User.all.count == 0
    #   @user.admin = true
    # end

    if @user.save
      flash[:notice] = "#{@user.username} successfully created."
      redirect_to user_path
    else
      render user_path
    end
  end

  # PUT /users/{username}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(
        :username, :password
    )
  end


end
