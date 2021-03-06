class FavoritesController < ApplicationController
  def create
  	if params[:recipe_id]
	  	@recipe = params[:recipe_id]
	  	@favorite = Favorite.create(user_id: current_user.id, recipe_id: @recipe)
	else
		@image = params[:imageUrl]
		@name = params[:recipeName]
		@source = params[:source]
		@url = params[:url]
		@time = params[:time]
		@yield = params[:yield]

		@recipe = Recipe.new(imageUrl: @image, recipeName: @name, source: @source, url: @url, time: @time, yield: @yield, recipeType: "web")
		if Recipe.where(url: @recipe.url).empty?
			@recipe.save
			@favorite = Favorite.create(user_id: current_user.id, recipe_id: @recipe.id)
		else
			@favorite = Favorite.create(user_id: current_user.id, recipe_id: Recipe.where(url: @recipe.url).first.id)
		end
	end

  end

  def show
  	if current_user
      @current_profile = Profile.where(user_id: current_user.id).first
    end

    @profiles = Profile.all
    @profile = Profile.where(user_id: current_user.id).first
    @recipes = Recipe.where(user_id: @profile.user_id)
    @favorites = Favorite.where(user_id: @profile.user_id)
    
    @fav_recipes = []
    @favorites.each do |favorite|
      @fav_recipes << Recipe.find(favorite.recipe_id)
    end 
  end

  def destroy
  	@user = User.find(current_user.id)
  	@recipe = Recipe.find(params[:recipe_id])
  	@favorite = Favorite.where(user_id: @user, recipe_id: @recipe).first
    @favorite.destroy
  end
end
