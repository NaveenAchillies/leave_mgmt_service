module LeaveEventsHelper

	FY_START_MONTH = 3
	
	def start_of_fy
        yr = (Time.now.month <= FY_START_MONTH) ? Time.now.year - 1 : Time.now.year
        Date.new(yr, FY_START_MONTH, 31)
    end

    def end_of_fy
        start_of_fy + 1.year - 1.day
    end
end
