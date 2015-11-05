class HomeController < ApplicationController
  	
  def index
  	if current_user
  		@profile = Profile.where(user_id: current_user.id).first
  	end
  end

end
