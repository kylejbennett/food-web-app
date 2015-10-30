class UsersController 

	def edit
	end

	def destroy
		@user = User.find(current_user.id)
	    @user.destroy
	    session[:user_id] = nil
	    flash[:alert] = "You're account has been deleted"
	    redirect_to root_path
	end

end
