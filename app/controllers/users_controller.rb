class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :currect_user, only: [:edit, :update]
  before_action :admin_user, only: :delete

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    redirect_to(root_path) if signed_in?
  	@user = User.new
  end

  def create
    redirect_to(root_path) if signed_in?
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    target = User.find(params[:id])
    if target == current_user
      flash[:error] = "Can not destroy admin user."
    else
      target.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    #Before actions

    def currect_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

