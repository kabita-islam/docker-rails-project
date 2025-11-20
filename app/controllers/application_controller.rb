class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  # before_action :authorize_request

  def authorize_request
    header = request.headers["Authorization"]

    token = header.split(" ").last if header

    decoded = JWT.decoded(token, Rails.application.credentials.secret_key_base)[0]
    saved_token = $redis.get("user: #{decoded[:user_id]}:token")

    if saved_token != token
      return render json: { error: "Invalid token" },status: :unauthorized
    end

    @current_user = User.find(decoded["user_id"])

  # rescue JWT::ExpiredSignature
  #   render json: {error: "Token expired"}, status: :unauthorized
  # rescue 
  #   render json: {error: "Invalid token"}, status: :unauthorized
  end

end
