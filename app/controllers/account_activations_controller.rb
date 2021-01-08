class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      #THESE LINES GO TO THE USER MODEL WHILE REFACTORING IN ACIVATE METHOD
      # user.update_attribute(:activated, true)
      # user.update_attribute(:activated_at, Time.zone.now)
      user.activate #see model
      log_in user
      flash[:success] = "Account activated!!"
      redirect_to user
    else
      flash[:danger] = "invalid activation link"
      redirect_to root_url
    end
  end
end
