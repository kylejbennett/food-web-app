class RecipesController < ApplicationController
  def index

    @term = params[:term]
    @results = search_recipe_by_term(@term)

  end

  def new

  end

  def create
  end

  def search

    # BY TERM

    @term = params[:term]
    @results = search_recipe_by_term(@term)['matches']
    @attribution = search_recipe_by_term(@term)['attribution']['html']

    # putting the relevant information into a hash

    @recipes = []

    @results.each do |recipe|
      recipe_info = get_recipe_by_id(recipe['id'])

      @recipes << {
        "name" => recipe['recipeName'],
        "source" => recipe['sourceDisplayName'],
        "id" => recipe['id'],
        "course" => recipe['attributes']['course'][0],
        "ingredients" => recipe['ingredients'],
        "rating" => recipe['rating'],
        "time" => recipe_info['totalTime'],
        "yield" => recipe_info['yield'],
        "url" => recipe_info['source']['sourceRecipeUrl'], 
        "image" => recipe_info['images'][0]['hostedLargeUrl']
      }
    end

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

  def show
  end

  def update
  end

  def destroy
  end

  private

  def search_recipe_by_term(term)
    results = URI("http://api.yummly.com/v1/api/recipes?_app_id=4c2c2d95&_app_key=4445cd6b516d461810d81c6a455293b1&q=#{term}")
    hash = JSON.parse(Net::HTTP.get(results))

  end

  def get_recipe_by_id(id)
    results = URI("http://api.yummly.com/v1/api/recipe/#{id}?_app_id=4c2c2d95&_app_key=4445cd6b516d461810d81c6a455293b1")
    recipe = JSON.parse(Net::HTTP.get(results))
  end
end
