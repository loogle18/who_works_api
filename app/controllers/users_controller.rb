class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(user_params)
    @user.save
  end

  private

  def user_params
    params.require(:user).permit(:login, :email, :password, :status_code, :status, :full_name, :avatar)
  end
end
