module ApplicationHelper
  def logged_in?
    !!session[:id]
  end

  def current_user
    User.find_by(id: session[:id]) if !!session[:id]
  end

  def authenticate_user
    unless logged_in?
      flash[:alert] = "User login required."
      redirect_to root_path
    end
  end
end
