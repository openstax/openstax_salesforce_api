class UsersController < ApplicationController
  before_action :require_user, except: :create

  def new
    @user = User.new
  end

  # GET /users
  def index
    @users = User.all.order('username asc')
  end

  # GET /users/{id}
  def show
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash.now[:notice] = 'User not found'
    redirect_to users_path
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "#{@user.username} successfully created."
      redirect_to users_path
    else
      render users_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/{username}
  def update
    @user = User.find(params[:id])
    if !@user.update(user_params)
      flash[:notice] = "#{@user.username} was not successfully updated."
      redirect_to edit_user_path
    else
      flash[:notice] = "#{@user.username} successfully updated."
      redirect_to users_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'User deleted'
    redirect_to users_path

  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :is_admin, :has_access)
  end


end
