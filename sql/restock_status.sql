WITH daily_used AS (
    -- Aggregate the total quantity of each menu item ordered per day
SELECT
	i.item_id, 
	i.item_name,
	i.item_size,
	i.sku,
	CAST(o.created_at AS DATE) AS order_date,
	SUM(o.quantity) AS daily_total
FROM orders o
	LEFT JOIN items i ON o.item_id = i.item_id
WHERE
	i.item_id IS NOT NULL
GROUP BY 
	i.item_id, 
	i.item_name, 
	i.item_size, 
	i.sku, 
	CAST(o.created_at AS DATE)
), 

f_daily AS (
    -- Calculate total ingredient usage per day based on recipe proportions
SELECT
	ing.ing_name, 
	r.ing_id,
	du.order_date, 
	SUM(du.daily_total * r.quantity)AS daily_u
FROM
	recipe r
	LEFT JOIN daily_used du ON r.recipe_id = du.sku
	LEFT JOIN ingredients ing ON ing.ing_id = r.ing_id
GROUP BY
	ing.ing_name,
	r.ing_id,
	du.order_date
)
    -- Calculate remaining stock over time and determine restock status
SELECT
	fd.ing_name, 
	fd.ing_id, 
	fd.order_date, 
	fd.daily_u, 
        -- Convert inventory stock units to match the unit used for ingredient consumption
	(inv.quantity * CAST(ing.ing_weight AS FLOAT)) - SUM(fd.daily_u) OVER (PARTITION BY fd.ing_id ORDER BY fd.order_date) AS remain_ing, 
	AVG(fd.daily_u) OVER (PARTITION BY fd.ing_id) AS avg_daily_used, 
	CASE 
		WHEN (inv.quantity * CAST(ing.ing_weight AS FLOAT)) - SUM(fd.daily_u) OVER (PARTITION BY fd.ing_id ORDER BY fd.order_date) <= 4*(AVG(fd.daily_u) OVER (PARTITION BY fd.ing_id))
		THEN 'Need to Restock' ELSE 'Sufficient Stock' END AS restock_status
 FROM
	f_daily fd
	LEFT JOIN inventory inv ON fd.ing_id = inv.ing_id
	LEFT JOIN ingredients ing ON fd.ing_id = ing.ing_id
ORDER BY
	fd.order_date