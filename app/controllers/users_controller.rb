class UsersController < ApplicationController
  # include ApplicationHelper

  # before_action :authenticate_user , except: [:new,:create]
  skip_before_action :verify_authenticity_token

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
      @user = User.new(user_params)

      if @user.save
        render json: { success: true, user: @user }
      else
        render json: { success: false, error: @user.error.message }
      end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: { success: true, user: @user }
    else
      render json: {success: false, error: @user.errors.messages }
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
