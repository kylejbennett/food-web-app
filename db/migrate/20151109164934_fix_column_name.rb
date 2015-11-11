class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :recipes, :type, :recipeType
  end
end
