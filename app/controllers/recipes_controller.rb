class RecipesController < ApplicationController
  before_filter :set_variables, :only =>[:index, :search, :next_page, :prev_page]
  before_filter :find_recipe, :only =>[:destroy, :update, :edit, :show]
  
  def index
    if current_user
      @recipes = Recipe.where(user_id: @profile.user_id)
    end

    @term = params[:term]
    @start = 0
    @results = search_recipe_by_term(@term, @page)

  end

  def new
    if current_user
      @user = User.find(current_user[:id])
    else
      flash[:notice] = "Please login or sign up"
      redirect_to new_user_session_path
    end

  end

  def create
    @user = User.find(current_user[:id])
    @recipe = Recipe.new(recipe_params)
    @recipe.update(user_id: @user[:id])
    if @recipe.save
      flash[:notice] = "Your recipe has been added!"
      redirect_to @recipe
    else
      flash[:alert] = "There was a problem with your recipe"
      redirect_to new_recipe_path
    end
  end

  def search

    if current_user
      @fav_recipes = []
      
      @favorites.each do |favorite|
        @fav_recipes << Recipe.find(favorite.recipe_id)
      end
    end

    # BY TERM
    @start = 0

    @term = params[:term]
    @hash = search_recipe_by_term(@term, @start)
    @results = @hash['matches']
    @result_count = @hash['totalMatchCount']

    @users_recipes_all = Recipe.where(["recipeName LIKE ?", "%#{@term}%"]).all
    @users_recipes = @users_recipes_all.where(recipeType: "user")

    # putting the relevant information into a hash

    @recipes = []

    @results.each do |recipe|
      recipe_info = get_recipe_by_id(recipe['id'])

      @recipes << {
        "name" => recipe['recipeName'],
        "source" => recipe['sourceDisplayName'],
        "id" => recipe['id'],
        "ingredients" => recipe['ingredients'],
        "rating" => recipe['rating'],
        "time" => recipe_info['totalTime'],
        "yield" => recipe_info['yield'],
        "url" => recipe_info['source']['sourceRecipeUrl'], 
        "image" => recipe_info['images'][0]['hostedLargeUrl']
      }
    end

    render 'index'

  end

  def next_page

    # BY TERM

    @start = params[:start].to_i + 10
    @term = params[:term]
    @hash = search_recipe_by_term(@term, @start)
    @results = @hash['matches']
    @result_count = @hash['totalMatchCount']

    # putting the relevant information into a hash

    @recipes = []

    @results.each do |recipe|
      recipe_info = get_recipe_by_id(recipe['id'])

      @recipes << {
        "name" => recipe['recipeName'],
        "source" => recipe['sourceDisplayName'],
        "id" => recipe['id'],
        "ingredients" => recipe['ingredients'],
        "rating" => recipe['rating'],
        "time" => recipe_info['totalTime'],
        "yield" => recipe_info['yield'],
        "url" => recipe_info['source']['sourceRecipeUrl'], 
        "image" => recipe_info['images'][0]['hostedLargeUrl']
      }
    end

    render 'index'

  end

  def prev_page

    # BY TERM

    @start = params[:start].to_i - 10
    @term = params[:term]
    @hash = search_recipe_by_term(@term, @start)
    @results = @hash['matches']
    @result_count = @hash['totalMatchCount']

    @recipes = []

    @results.each do |recipe|
      recipe_info = get_recipe_by_id(recipe['id'])

      @recipes << {
        "name" => recipe['recipeName'],
        "source" => recipe['sourceDisplayName'],
        "id" => recipe['id'],
        "ingredients" => recipe['ingredients'],
        "rating" => recipe['rating'], 
        "time" => recipe_info['totalTime'],
        "yield" => recipe_info['yield'],
        "url" => recipe_info['source']['sourceRecipeUrl'], 
        "image" => recipe_info['images'][0]['hostedLargeUrl']
      }
    end

    render 'index'

  end

  def show
    @recipe_created_by = Profile.find(@recipe[:user_id])

    if current_user
      @profile = Profile.find_by(user_id: current_user.id)
      @favorites = Favorite.where(user_id: @profile.user_id)
    end 
  end

  def edit

  end

  def update

    if @recipe.update(recipe_params)
      flash[:notice] = "Recipe info updated!"
      redirect_to @recipe
    else
      flash[:alert] = "There was a problem updating your Recipe"
    end

  end

  def destroy
    
    @recipe.destroy
    flash[:alert] = "Recipe has been deleted"
    redirect_to recipes_path
  end

  private

  def set_variables
    if current_user
      @profile = Profile.find_by(user_id: current_user.id)
      @favorites = Favorite.where(user_id: @profile.user_id)
    end
    @profiles = Profile.all
    @user_recipes = Recipe.where(recipeType: "user").last(10)
    
  end

  def find_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    allow = [:recipeName, :source, :url, :course, :cuisine, :time, :yield, :ingredients, :instructions, :user_id, :avatar, :recipeType]
    params.require(:recipe).permit(allow)
  end

  def search_recipe_by_term(term, start)
    results = URI("http://api.yummly.com/v1/api/recipes?_app_id=4c2c2d95&_app_key=4445cd6b516d461810d81c6a455293b1&q=#{term}&maxResult=10&start=#{start}")
    x = Net::HTTP.get(results)  
    hash = JSON.parse(x)

  end

  def get_recipe_by_id(id)
    results = URI("http://api.yummly.com/v1/api/recipe/#{id}?_app_id=4c2c2d95&_app_key=4445cd6b516d461810d81c6a455293b1")
    x = Net::HTTP.get(results)
    recipe = JSON.parse(x)
  end
end
