class UsersController < ApplicationController
  
  before_filter :authenticate, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, :only => :destroy

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
    @title = "All users"
  end

  def new
  	@title = "Sign up"
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def create
  	
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		redirect_to @user, flash: { success: "Welcome to the Sample app!" }
  	else
  		@title = "Sign up"
  		render 'new'
  	end
  end

  def edit
   # @user = User.find(params[:id]) // already present in before_filter
    @title = "Edit user"
  end

  def update
   # @user = User.find(params[:id]) // already present in before_filter
    if @user.update_attributes(user_params)
      #it worked
      redirect_to @user, flash: { success: "Profile updated!" }
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path, flash: { success: "User destroyed"}
  end


  private
  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def authenticate
   # flash[:notice] = "Please sign in to access this page.."
    deny_access unless  signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless  current_user?(@user) #// same as =>  @user == current_user
  end
  
  def admin_user
    user = User.find(params[:id])
    redirect_to(root_path) unless (current_user.admin? && !current_user?(user))
      
  end
end
