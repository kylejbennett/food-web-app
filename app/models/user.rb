class User < ActiveRecord::Base
	has_one :profile, dependent: :destroy
	accepts_nested_attributes_for :profile

	has_many :favorites, foreign_key: :user_id, dependent: :destroy

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :confirmable, :database_authenticatable, :registerable,
	    :recoverable, :rememberable, :trackable, :validatable

	has_many :recipes, dependent: :destroy
end
