class UsersController < ApplicationController
  before_action :require_user, except: :create

  # GET /users
  def index
    @users = User.all
    #render json: @users, status: :ok
  end

  # GET /users/{id}
  def show
    @user = User.find(params[:id])
    puts '*** User: ' + @user.inspect
    #render edit_user_path(@user)
    #render json: @user, status: :ok
  rescue ActiveRecord::RecordNotFound
    #render json: { errors: 'User not found' }, status: :not_found
    flash.now[:notice] = 'User not found'
    redirect_to user_path
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

  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/{username}
  def update
    @user = User.find(params[:id])
    if !@user.update(user_params)
      # render json: { errors: @user.errors.full_messages },
      #        status: :
      flash[:notice] = "#{@user.username} was not successfully updated."
      redirect_to edit_user_path
    else
      flash[:notice] = "#{@user.username} successfully updated."
      redirect_to users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :is_admin, :has_access)
  end


end
