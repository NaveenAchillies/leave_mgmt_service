class LeavePeroid < ApplicationRecord
	extend LeaveEventsHelper
	# validate :validate_peroid
	before_create :set_peroid
	after_commit :clear_cache, on: :update
	belongs_to :user
	delegate :email, to: :user

	default_scope do
		current_user = Thread.current[:current_user]
		case current_user.role
		when 'user'
			where("start_time >= ? and end_time <= ?", start_of_fy, end_of_fy)
		when 'admin'
			order(:end_time,:start_time)
		end if current_user.present?
		where(false)
	end

	def set_peroid
		self.start_time = LeavePeroid.start_of_fy
		self.end_time = LeavePeroid.end_of_fy
	end

	def clear_cache
		Rails.cache.delete('leave_peroids')
		# $redis.del("leave_peroids")
	end

end
