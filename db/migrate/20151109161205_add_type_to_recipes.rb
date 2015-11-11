class AddTypeToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :type, :string
  end
end
