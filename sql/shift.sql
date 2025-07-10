    -- Calculate working hours for each shift
SELECT 
	shift_id, 
	day_of_week, 
	start_time, 
	end_time, 
	DATEDIFF(HOUR, start_time, end_time) AS worked_hr
FROM shift