class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :fname
      t.string :lname
      t.date :birthdate
      t.string :email
      t.string :bio
      t.string :username
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
