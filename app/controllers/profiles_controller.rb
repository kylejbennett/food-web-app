class ProfilesController < ApplicationController

  before_action :authenticate_user!

  def index
    @profiles = Profile.all
  end

  def new
    @user = User.find(current_user[:id])
    
    if Profile.where(user_id: current_user.id).first == nil
      @profile = Profile.create(user_id: current_user.id)
    else
      @profile = Profile.where(user_id: current_user.id).first
    end
    
  end

  def show
    if current_user
      @current_profile = Profile.where(user_id: current_user.id).first
    end

    @profiles = Profile.all
    @profile = Profile.find(params[:id])
    @recipes = Recipe.where(user_id: @profile.user_id)
    @favorites = Favorite.where(user_id: @profile.user_id)
    
    @fav_recipes = []
    @favorites.each do |favorite|
      @fav_recipes << Recipe.find(favorite.recipe_id)
    end
    
  end

  def create
    
  end

  def update
    @profile = Profile.where(user_id: current_user.id).first

    if @profile.update(profile_params)
      flash[:alert] = "Your profile was updated successfully."
      redirect_to @profile
    else
      flash[:alert] = "There was a problem updating your profile."
      render :new
    end

  end

  def destroy
    @user = User.find(current_user.id)
    @user.destroy
    session[:user_id] = nil
    flash[:alert] = "You're account has been deleted"
    redirect_to root_path
  end

  private

  def profile_params
    allow = [:username, :fname, :lname, :email, :avatar, :birthdate, :bio]
    params.require(:profile).permit(allow)
  end

end
