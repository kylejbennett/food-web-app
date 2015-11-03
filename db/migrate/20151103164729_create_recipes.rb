class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :recipeName
      t.string :yummlyID
      t.string :source
      t.string :imageUrl
      t.string :course
      t.string :cuisine
      t.string :ingredients
      t.integer :rating
      t.string :time
      t.string :url
      t.string :user_id
      t.text :instructions

      t.timestamps null: false
    end
  end
end
