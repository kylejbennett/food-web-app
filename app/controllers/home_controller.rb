class HomeController < ApplicationController
	attr_accessor :photo
  	
  	def index
  		@results = search_recipe_by_term('chicken')

  		@recipe_info = []

  		@results.each do |recipe|
			@recipe_info << get_recipe_by_id(recipe['id'])['images'][0]['hostedLargeUrl']
  		end

  		

  		@recipe = get_recipe_by_id('Cheesy-Buffalo-Chicken-Bombs-1354950')

  		@recipe_name = @results.first['recipeName']
  		@recipe_source = @results.first['sourceDisplayName']
  		@recipe_photo = @recipe['images'][0]['hostedLargeUrl']
  		
  	end

  	def search_recipe_by_term(term)
		results = URI("http://api.yummly.com/v1/api/recipes?_app_id=4c2c2d95&_app_key=4445cd6b516d461810d81c6a455293b1&q=#{term}")
		hash = JSON.parse(Net::HTTP.get(results))
		recipes = hash['matches']
	end

	def get_recipe_by_id(id)
		results = URI("http://api.yummly.com/v1/api/recipe/#{id}?_app_id=4c2c2d95&_app_key=4445cd6b516d461810d81c6a455293b1")
		recipe = JSON.parse(Net::HTTP.get(results))
	end

# puts "What ingredient would you like to search for?"
# term = gets
# my_recipes = search_recipe_by_term(term)

# for recipe in my_recipes
# 	puts recipe['recipeName']
# 	puts recipe['sourceDisplayName']
# 	puts recipe['id']
# end

# id = my_recipes.first['id']

# my_recipe = get_recipe_by_id(id)

# puts my_recipe['name'] + " " + my_recipe['source']["sourceRecipeUrl"] + " " + my_recipe['images'][0]['hostedLargeUrl']
end
