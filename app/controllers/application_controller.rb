class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def authorize_request
    header = request.headers["Authorization"]

    return render json: { error: "token missing " }, status: :unauthorized if header.blank?

    access_token = header.split(" ").last if header

    decoded = JWT.decode(
          access_token,
          Rails.application.credentials.secret_key_base,
          true,
          { algorithm: 'HS256' }
        )[0]

    user_id = decoded["user_id"]
    saved_token = $redis.get("user:#{user_id}:access_token")

    if saved_token != access_token
      return render json: { error: "Invalid token" },status: :unauthorized
    end

    @current_user = User.find(decoded["user_id"])
  end

end
