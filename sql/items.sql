    -- Round item_price to 2 decimal places
SELECT
	item_id, 
	sku, 
	item_name, 
	item_cat, 
	item_size, 
	ROUND(item_price, 2) AS item_price
FROM
	items