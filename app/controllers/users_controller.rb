class UsersController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user, only: %i[index edit update]
  before_action :admin_user,     only: :destroy
  before_action :set_user, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[edit update]

  # GET /users and paginates the page
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save && !current_user.admin?
        flash[:success] = "Account created successfully!"
        login(@user)
        format.html { redirect_to user_url(@user) }
      #option to add a student  
      elsif current_user.admin? && @user.save
        flash[:success] = "Student added successfully!"
        format.html { redirect_to users_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user)}
        flash[:success] = "Account updated successfully!"
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DESTROY /user
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = 'User deleted'
    redirect_to users_path
  end

  # Make the specified user an admin (instructor)
  def make_admin
    user = User.find params[:id]
    user.update_attribute( "admin", true )
    redirect_to "/users/#{user.id}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please log in.'
      redirect_to login_url, status: :see_other
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url, status: :see_other) if logged_in? && !current_user.admin?
  end

end
