class LeaveEvent < ApplicationRecord
	belongs_to :user
	has_many :leave_peroids, foreign_key: :user_id, primary_key: :user_id 
	enum status: %i[applied approved rejected]
	validate :validate_leaves
  	validates_presence_of :start_time, :end_time
  	after_commit :apply_leave, :clear_event_cache, on: :update
  	before_save :set_status_change
  	attr_accessor :status_change

  	default_scope do
		current_user = Thread.current[:current_user]
		case current_user.role
		when 'user'
			where(:user_id=>current_user.id)
		when 'admin'
			order(:status, :end_time, :start_time)
		end if current_user.present?
		where(false)
	end

	def set_status_change
		self.status_change = (self.new_record? or (self.status_changed? and !self.errors.present?))
		Rails.logger.debug "In set_status_change status_change = #{self.status_change}"
	end

	def validate_leaves
		current_user = Thread.current[:current_user]
		self.hours = ((end_time - start_time) / 1.hour).round
		errors.add(:base, "leave cannot be applied in this date range") if hours < 0
		errors.add(:base, "leave not yet assigned") unless leave_peroids.present?
		errors.add(:base, "leave cannot be #{self.status}") if status_change && self.status_was != "applied"
		if current_user.present? && current_user.leave_peroids.present?
			used = current_user.leave_peroids.sum(:used)
			assigned = current_user.leave_peroids.sum(:assigned)
			errors.add(:base, "no more leaves") if used >= assigned
			leaves_left = assigned - used
			errors.add(:base, "leaves left #{leaves_left}") if (leaves_left - self.hours/24.to_f) <= 0
		end
	end

	def apply_leave
		leave = self.leave_peroids.last
		if leave.present? && self.approved? && status_change
			leave.used += self.hours/24.to_f
			leave.save
		end
	end

	def clear_event_cache
		$redis.del("leave_events")
	end

end
