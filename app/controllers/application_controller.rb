class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  # before_action :authorize_request

  def authorize_request
    header = request.headers["Authorization"]

    return render json: { error: "token missing " }, status: :unauthorized if header.blank?

    token = header.split(" ").last if header

    decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    user_id = decoded["user_id"]
    saved_token = $redis.get("user:#{user_id}:token")
    # saved_token = $redis.get("user: #{decoded['user_id']}:token")

    if saved_token != token
      return render json: { error: "Invalid token" },status: :unauthorized
    end

    @current_user = User.find(decoded["user_id"])
  end

end
