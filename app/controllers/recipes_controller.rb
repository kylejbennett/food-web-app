class RecipesController < ApplicationController
  def index
    @profiles = Profile.all
    @user_recipes = Recipe.where(recipeType: "user")

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
    @profiles = Profile.all
    @user_recipes = Recipe.where(recipeType: "user")
    # BY TERM

    @term = params[:term]
    @start = 0
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

    # @city_values = []

    # for i in 0..19 do
    #   biz = map_params(@location, @term, @radius, @offset)

    #   if !biz.businesses.empty?
    #     @city_values << biz
    #     @offset+=20
    #   else
    #     break
    #   end
    # end

    render 'index'

    # EACH
    # @recipe_name = @results.first['recipeName']
    # @recipe_id = @results.first['id']
    # @recipe_source = @results.first['sourceDisplayName']
    # @recipe_image = @results.first['imageUrlsBySize']['90']
    # @recipe_course = @results.first['attributes']['course'][0]
    # @recipe_cuisine = @results.first['attributes']['cuisine'][0]
    # @recipe_ingredient_array = @results.first['ingredients']
    # @recipe_rating = @results.first['rating']
    # @recipe_time = @results.first["totalTimeInSeconds"]
    
    # BY ID

    # @recipe_info = []

    # @results.each do |recipe|
    #    @recipe_info << get_recipe_by_id(recipe['id'])['images'][0]['hostedLargeUrl']
    # end

    # @recipe = get_recipe_by_id('Cheesy-Buffalo-Chicken-Bombs-1354950')

    #   @recipe_sm_photo = @recipe['images'][0]['hostedSmallUrl']
    #   @recipe_md_photo = @recipe['images'][0]['hostedMediumUrl']
    #   @recipe_lg_photo = @recipe['images'][0]['hostedLargeUrl']

    #   @yield = recipe['yield']
    #   @total_time = recipe['totalTime']
    #   @course = recipe['attributes']['course'][0]
    #   @ingredient_array = recipe['ingredientLines']
    #   @source = recipe['source']['sourceDisplayName']
    #   @recipe_url = recipe['source']['sourceRecipeUrl']


  end

  def next_page
    @profiles = Profile.all
    @user_recipes = Recipe.all
    # BY TERM

    @term = params[:term]
    @start = params[:start].to_i + 10
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
    @profiles = Profile.all
    @user_recipes = Recipe.all
    # BY TERM

    @term = params[:term]
    @start = params[:start].to_i - 10
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

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_created_by = Profile.find(@recipe[:user_id])
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])

    if @recipe.update(recipe_params)
      flash[:notice] = "Recipe info updated!"
      redirect_to @recipe
    else
      flash[:alert] = "There was a problem updating your Recipe"
    end

  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    flash[:alert] = "Recipe has been deleted"
    redirect_to recipes_path
  end

  private

  def recipe_params
    allow = [:recipeName, :source, :url, :course, :cuisine, :time, :yield, :ingredients, :instructions, :user_id, :avatar, :recipeType]
    params.require(:recipe).permit(allow)
  end

  def search_recipe_by_term(term, start)
    results = URI("http://api.yummly.com/v1/api/recipes?_app_id=4c2c2d95&_app_key=4445cd6b516d461810d81c6a455293b1&q=#{term}&maxResult=10&start=#{start}")
    hash = JSON.parse(Net::HTTP.get(results))

  end

  def get_recipe_by_id(id)
    results = URI("http://api.yummly.com/v1/api/recipe/#{id}?_app_id=4c2c2d95&_app_key=4445cd6b516d461810d81c6a455293b1")
    recipe = JSON.parse(Net::HTTP.get(results))
  end
end
