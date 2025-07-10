SELECT
	*
FROM (
    -- Fill NULL or blank 'in_or_out' values
SELECT  
    row_id,
	order_id, 
    created_at,
	item_id, 
	quantity, 
	cust_name, 
    CASE 
        WHEN in_or_out IS NOT NULL
            AND LTRIM(RTRIM(in_or_out)) NOT LIKE ''
            THEN in_or_out
        ELSE MAX(CASE 
                    WHEN in_or_out IS NOT NULL
                        AND LTRIM(RTRIM(in_or_out)) NOT LIKE ''
                        THEN in_or_out
                    END) OVER (PARTITION BY order_id)
        END AS in_or_out
FROM 
    orders
) AS sub_query
WHERE 
    -- Remove invalid item_ids
    item_id LIKE 'It___' AND 
    item_id BETWEEN 'It001' AND 'It024'