class User < ActiveRecord::Base
	has_one :profile, dependent: :destroy
	accepts_nested_attributes_for :profile
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :confirmable, :database_authenticatable, :registerable,
	    :recoverable, :rememberable, :trackable, :validatable
end
