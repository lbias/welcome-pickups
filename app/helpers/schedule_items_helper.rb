module ScheduleItemsHelper
	def duration_s minutes
		"#{minutes.to_i/60} hours and #{minutes.to_i % 60} minutes"
	end

	def pretty_date date_s
		date_s.to_date.strftime('%A, %d %B %Y')
	end
end
