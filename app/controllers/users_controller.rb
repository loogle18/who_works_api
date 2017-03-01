class UsersController < ApplicationController
  before_action :find_user, only: %i(update update_status)

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

  def update
    if @user.update(update_user_params)
      render nothing: true, status: 200
    else
      render json: @user.errors.full_messages, status: 406
    end
  end

  def update_status
    status_code = status_code_params[:status_code]

    if @user && status_code
      if User::VALID_STATUS_CODES.include? status_code.to_i
        @user.update_column(:status_code, status_code)
      else
        render json: 'Invalid status code!', status: 406
      end
    else
      render nothing: true, status: 404
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
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

  def find_user
    @user ||= User.find(params[:user][:id])
  end

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

  def update_user_params
    params.require(:user).permit(:login, :full_name, :status, :password)
  end

  def status_code_params
    params.require(:user).permit(:id, :status_code)
  end
end
