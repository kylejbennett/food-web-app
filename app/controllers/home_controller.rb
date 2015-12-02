class HomeController < ApplicationController
  	
	def index
	  	if current_user
	  		if Profile.where(user_id: current_user.id).first == nil
		        @profile = Profile.create(user_id: current_user.id)
		    else
		        @profile = Profile.where(user_id: current_user.id).first
		    end
	  	end
	end

	

end
