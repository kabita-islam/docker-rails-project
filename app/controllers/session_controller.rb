class SessionController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_by(name: params[:name])
    
    if user && user.authenticate(params[:password])
      token = JWT.encode(
        {
          user_id: user.id,
          exp: 1.minute.from_now.to_i
        },Rails.application.credentials.secret_key_base
      )
      $redis.set("user:#{user.id}:token",token)
      $redis.expire("user:#{user.id}:token",1.minute.to_i)
      render json: {
        token: token
      },status: :ok
      # flash[:success] = "logged in successfully"
      # session[:id] = user.id
      # redirect_to user_path(user)
    else
      render json: { error: "Invalid credentials" },status: :unauthorized
      # flash[:alert] = "Something is going wrong."
      # render :login
    end
  end

  def logout
    user_id = @current_user.id
    $redis.del("user:#{user_id}:token")
    render json: {message: "Logged out"}, status: :ok
    # session[:id] = nil
    # flash[:success] = "logged out successfully"
    # redirect_to root_path
  end
end