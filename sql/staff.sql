    -- Convert 'sal_per_hour' from time format to numeric hour value for salary calculations
SELECT
	staff_id, 
	first_name, 
	last_name, 
	position, 
	CAST(DATEDIFF(HOUR, '00:00:00', sal_per_hour) AS FLOAT) AS sal_per_hour
FROM staff