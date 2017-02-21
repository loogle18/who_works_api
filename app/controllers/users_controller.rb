class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users.order(:login).as_json(except: columns_to_exclude)
  end

  def create
    @user = User.new(new_user_params)

    if @user.save
      render json: @user.as_json(except: columns_to_exclude)
    else
      render json: @user.errors.full_messages, status: 406
    end
  end

  def auth
    email = auth_user_param[:email]
    password = auth_user_param[:password]

    if @user = User.find_by(email: email)
      if valid_password?(@user, password)
        render json: @user.as_json(except: columns_to_exclude)
      else
        render nothing: true, status: 401
      end
    else
      render nothing: true, status: 404
    end
  end

  private

  def columns_to_exclude
    %i(password_digest created_at updated_at)
  end

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
