class ChangeDataTypeForUserid < ActiveRecord::Migration
  def self.up
  	change_table :recipes do |t|
  		t.change :user_id, :integer
  	end
  end

  def self.down
  	change_table :recipes do |t|
  		t.change :user_id, :string
  	end
  end

end
