class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(new_user_params)
    @user.save
  end

  def auth
    email = auth_user_param[:email]
    password = auth_user_param[:password]
    user = User.find_by(email: email)

    if user.present?
      if valid_password?(user, password)
        render json: user
      else
        render nothing: true, status: 401
      end
    else
      render nothing: true, status: 404
    end
  end

  private

  def valid_password?(user, password)
    current_password = BCrypt::Password.new(user.password_digest)
    current_password == password
  end

  def auth_user_param
    params.require(:user).permit(:email, :password)
  end

  def new_user_params
    params.require(:user).permit(:login, :email, :password, :status_code, :status, :full_name, :avatar)
  end
end