class User < ApplicationRecord
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :lockable, :timeoutable
	# has_one :role, :foreign_key=> :id, :primary_key => :role_id
	enum role: %i[user admin]
	has_many :leave_events
	has_many :leave_peroids


	def admin?
		self.role == "admin"
	end


	def leaves_left
		leave_peroids.sum(:assigned) - leave_peroids.sum(:used).to_f
	end
	
end
