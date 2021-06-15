class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[ index show new create posts ]
  before_action :set_user, only: %i[ show edit update destroy posts ]
  before_action :require_permission, only: %i[ edit update destroy ]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    filtered_params = user_params
    if ((filtered_params[:password].nil? || filtered_params[:password].length == 0) && (filtered_params[:password_confirmation].nil? || filtered_params[:password_confirmation].length == 0)) || !allow_password_change?(@user)
      # Do not attempt to update the password; remove it from the hash
      filtered_params.delete(:password)
      filtered_params.delete(:password_confirmation)
    else
      # Request to clear the salt so that a new one will be given
      filtered_params[:salt] = nil
    end
    filtered_params.delete(:username) unless allow_username_change?(@user)
    respond_to do |format|
      if @user.update(filtered_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    if allow_user_destroy?(@user)
      @user.destroy
      success = true
    else
      success = false
    end
    respond_to do |format|
      if success
        format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      else
        format.html { unauthorized_redirect_to @user }
      end
    end
  end

  # GET /users/1/posts
  def posts
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      sanitize params.require(:user).permit(:username, :password, :password_confirmation, :display_name, :about_me, :avatar)
    end

    def require_permission
      unless higher_rank?(@user)
        unauthorized_redirect_to @user
      end
    end
end
