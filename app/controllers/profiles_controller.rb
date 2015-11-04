class ProfilesController < ApplicationController

  before_action :authenticate_user!

  def index
    @profiles = Profile.all
  end

  def new
    @user = User.find(current_user[:id])
    
    if Profile.where(user_id: current_user.id).first == nil
      @current_profile = Profile.create(user_id: current_user.id)
    else
      @current_profile = Profile.where(user_id: current_user.id).first
    end
    
  end

  def show
    @current_profile = Profile.where(user_id: current_user.id).first
    @profile = Profile.find(params[:id])
  end

  def create
    
  end

  def update
    @current_profile = Profile.where(user_id: current_user.id).first

    if @current_profile.update(profile_params)
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
