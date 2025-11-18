class SessionController < ApplicationController
  def create
    user = User.find_by(name: params[:name])
    
    if user && user.authenticate(params[:password])
      flash[:success] = "logged in successfully"
      session[:id] = user.id
      redirect_to user_path(user)
    else
      flash[:alert] = "fjdmcls"
      render :login
    end
  end

  def logout
    session[:id] = nil
    flash[:success] = "logged out successfully"
    redirect_to root_path
  end
end