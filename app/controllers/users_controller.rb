class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
    # @users = User.where(activated: true).paginate(page: params[:page])
  end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    unless @user.activated?
      flash[:warning] = "#{@user.name} is still not activated!!"
      redirect_to root_url
    end 
    # debugger
  end
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      # flash[:success] = "Welcome to the Sample App"
      # redirect_to @user

      # THIS LINE GOES TO USER MODEL WHILE REFACTORING IN SEND_ACTIVATION_EMAIL
      # UserMailer.account_activation(@user).deliver_now #adds mail_to with subject
      @user.send_activation_email #see model
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "User successfully updated!!"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  #Before Filters
  

  #Confirms the correct user
  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = "Unauthorized Access!!"
      redirect_to(root_url) 
    end
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
