    -- Round ing_price to 2 decimal places
SELECT
	ing_id, 
	ing_name, 
	ing_weight, 
	ing_meas, 
	ROUND(ing_price, 2) AS ing_price
FROM
	ingredients