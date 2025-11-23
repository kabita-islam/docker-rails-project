class SessionController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, only: [:logout]
  skip_before_action :authorize_request, only: [:login, :refresh]


  def login
    user = User.find_by(name: params[:name])
    
    if user && user.authenticate(params[:password])
      access_token = JWT.encode(
        {
          user_id: user.id,
          exp: 1.minute.from_now.to_i
        },
        Rails.application.credentials.secret_key_base, 'HS256'
      )

      refresh_token = JWT.encode(
        {
          user_id: user.id,
          exp: 5.minute.from_now.to_i
        },
        Rails.application.credentials.secret_key_base, 'HS256'
      )
      $redis.set("user:#{user.id}:access_token", access_token)
      $redis.expire("user:#{user.id}:access_token", 1.minute.to_i)

      $redis.set("user:#{user.id}:refresh_token", refresh_token)
      $redis.expire("user:#{user.id}:refresh_token", 5.minute.to_i)

      render json: {
        access_token: access_token,
        refresh_token: refresh_token
      },status: :ok
    else
      render json: { error: "Invalid credentials" },status: :unauthorized
    end
  end


  def refresh 
      refresh_token = request.headers["Refresh-Token"]

      decoded = JWT.decode(refresh_token, Rails.application.credentials.secret_key_base)[0]
      user_id = decoded["user_id"]
      saved_token = $redis.get("user:#{user_id}:refresh_token")

      if saved_token != refresh_token
        return render json: { error: "Invalid Refresh Token" }, status: :unauthorized
      end

      new_access_token = JWT.encode(
        {
          user_id: user_id,
          exp: 1.minute.from_now.to_i
        },Rails.application.credentials.secret_key_base
      )

      render json: { access_token: new_access_token }

      $redis.set("user:#{user_id}:access_token", new_access_token)
      $redis.expire("user:#{user_id}:access_token", 1.minute.to_i)

    rescue JWT::ExpiredSignature
      render json: {error: "Token has expired" }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: "Invalid Token" },status: :unauthorized
  end

  def logout
    user_id = @current_user.id
    $redis.del("user:#{user_id}:access_token")
    render json: {message: "Logged out"}, status: :ok
  end
end