class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user &.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "Welcome back #{user.name}"
      redirect_to user
    else
      flash.now[:danger] = "Invalid Email/Password"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = "You are successfully logged out!!"
    redirect_to root_url
  end
end
