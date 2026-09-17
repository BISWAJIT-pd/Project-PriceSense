SELECT * FROM e_cell_project.cleaned_final_df;
use e_cell_project;
select `channel`,round(sum(price*quantity),2) as 'Revenue' from cleaned_final_df
group by channel order by `Revenue` DESC;
select `state`,round(sum(price*quantity),2) as 'Revenue' from cleaned_final_df
group by state order by `Revenue` DESC;
select `occasion`,round(sum(price*quantity),2) as 'Revenue' from cleaned_final_df
group by occasion order by `Revenue` DESC;
select `dietary_restriction`,round(sum(price*quantity),2) as 'Revenue' from cleaned_final_df
group by dietary_restriction order by `Revenue` DESC;
select `trend_affinity`,round(sum(price*quantity),2) as 'Revenue' from cleaned_final_df
group by trend_affinity order by `Revenue` DESC;
select `age_group`,round(sum(price*quantity),2) as 'Revenue' from cleaned_final_df
group by age_group order by `Revenue` DESC;

-- Top 10 Most Selling Products Units
select product_id,sum(quantity) as 'Total_quantity' from cleaned_final_df
group by product_id order by Total_quantity desc limit 10;
-- Compare sales volume and revenue performance across different states and sales channels
select state,channel,sum(quantity) as 'Total_quantity',round(sum(price*quantity),2) as 'Revenue'
 from cleaned_final_df
group by state,channel order by Total_quantity desc;
-- Monthly Sales report
SELECT 
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    ROUND(SUM(price * quantity), 2) AS Revenue
FROM cleaned_final_df
GROUP BY MONTH(date), MONTHNAME(date)
ORDER BY MONTH(date);

select CAST(price AS SIGNED) AS price,sum(quantity) as 'Units sold'
,round(sum(price*quantity),2) as 'Revenue' from cleaned_final_df
group by price order by `Units sold` desc;
WITH price_demand AS (
	SELECT FLOOR(price) AS price,SUM(quantity) AS total_quantity
    FROM cleaned_final_df GROUP BY FLOOR(price))
SELECT
    price,total_quantity,LAG(total_quantity)
	OVER (ORDER BY price) AS previous_quantity,
    ROUND(
        (
            total_quantity -LAG(total_quantity) OVER (ORDER BY price)
        )
        /   LAG(total_quantity) OVER (ORDER BY price)* 100,2) 
	AS demand_change_pct
FROM price_demand
ORDER BY price limit 50;

WITH price_demand AS (
    SELECT
        FLOOR(price) AS price,SUM(quantity) AS total_quantity
    FROM cleaned_final_df GROUP BY FLOOR(price)
),
changes AS (
    SELECT
        price,
        total_quantity,
        LAG(price) OVER (ORDER BY price) AS previous_price,
        LAG(total_quantity) OVER (ORDER BY price) AS previous_quantity
    FROM price_demand
)
SELECT
    price,total_quantity,previous_price,previous_quantity,
    ROUND(
        (price - previous_price)
        / previous_price * 100,
        2
    ) AS price_change_pct,

    -- % Change in Quantity
    ROUND(
        (total_quantity - previous_quantity)
        / previous_quantity * 100,
        2
    ) AS quantity_change_pct,
    ROUND(
        (
            (total_quantity - previous_quantity)
            / previous_quantity
        )/((price - previous_price)/ previous_price),2
    ) AS price_elasticity
FROM changes WHERE previous_price IS NOT NULL ORDER BY price;

select income_bracket,round(avg(price),2) as 'Avg_price'
,count(quantity) as 'Units',round(sum(price*quantity),2) as 'Revenue'
from cleaned_final_df group by income_bracket;

select occasion,trend_affinity,count(quantity) as 'Units',
round(sum(price*quantity),2) as 'Revenue'
from cleaned_final_df group by occasion,trend_affinity;

SELECT
    CASE
        WHEN HOUR(time) >= 5 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 17 THEN 'Afternoon'
        WHEN HOUR(time) >= 17 AND HOUR(time) < 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_category,

    category,

    SUM(quantity) AS total_units

FROM cleaned_final_df

GROUP BY
    CASE
        WHEN HOUR(time) >= 5 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 17 THEN 'Afternoon'
        WHEN HOUR(time) >= 17 AND HOUR(time) < 21 THEN 'Evening'
        ELSE 'Night'
    END,
    category;
    
SELECT
CASE
    WHEN price < 10 THEN '0-10'
    WHEN price < 20 THEN '10-20'
    WHEN price < 30 THEN '20-30'
    WHEN price < 40 THEN '30-40'
    WHEN price < 50 THEN '40-50'
    ELSE '50+'
END AS price_range,
SUM(quantity) AS total_units,
COUNT(*) AS orders,ROUND(sum(price*quantity),2) AS revenue
FROM cleaned_final_df GROUP BY price_range ORDER BY MIN(price);

SELECT
CASE
    WHEN price < 10 THEN '0-10'
    WHEN price < 20 THEN '10-20'
    WHEN price < 30 THEN '20-30'
    WHEN price < 40 THEN '30-40'
    WHEN price < 50 THEN '40-50'
    ELSE '50+'
END AS price_range,
SUM(quantity) AS total_units,
COUNT(*) AS orders,ROUND(sum(price*quantity),2) AS revenue
FROM cleaned_final_df where persona='fitness'
 GROUP BY price_range ORDER BY MIN(price);
 
select city_tier,`channel`,COUNT(*) AS orders,SUM(quantity) AS total_units
FROM cleaned_final_df 
GROUP BY city_tier,`channel`;
 
-- claims based attributes analysis

SELECT
    'clean-label' AS attribute,
    `clean-label` AS attribute_value,
    COUNT(*) AS total_records,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price * quantity), 2) AS revenue,
    ROUND(
        SUM(price * quantity) / NULLIF(SUM(quantity), 0),
        2
    ) AS avg_price_per_unit
FROM cleaned_final_df
GROUP BY `clean-label`

UNION ALL

SELECT
    'diabetic-friendly',
    `diabetic-friendly`,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY `diabetic-friendly`

UNION ALL

SELECT
    'gluten-free',
    `gluten-free`,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY `gluten-free`

UNION ALL

SELECT
    'halal',
    halal,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY halal

UNION ALL

SELECT
    'high-protein',
    `high-protein`,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY `high-protein`

UNION ALL

SELECT
    'jain-friendly',
    `jain-friendly`,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY `jain-friendly`

UNION ALL

SELECT
    'keto-friendly',
    `keto-friendly`,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY `keto-friendly`

UNION ALL

SELECT
    'kosher',
    kosher,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY kosher

UNION ALL

SELECT
    'low-sugar',
    `low-sugar`,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY `low-sugar`

UNION ALL

SELECT
    'nut-free',
    `nut-free`,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY `nut-free`

UNION ALL

SELECT
    'plant-based',
    `plant-based`,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY `plant-based`

UNION ALL

SELECT
    'vegan',
    vegan,
    COUNT(*),
    SUM(quantity),
    COUNT(DISTINCT order_id),
    ROUND(SUM(price * quantity), 2),
    ROUND(SUM(price * quantity) / NULLIF(SUM(quantity), 0), 2)
FROM cleaned_final_df
GROUP BY vegan

ORDER BY attribute, attribute_value;
-- analysis on ingredients tags 
SELECT
    ingredient,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS total_units,
    ROUND(SUM(price * quantity), 2) AS revenue
FROM (
    SELECT order_id, price, quantity, 'almond-flour' AS ingredient
    FROM cleaned_final_df WHERE `almond-flour` = 1

    UNION ALL

    SELECT order_id, price, quantity, 'collagen'
    FROM cleaned_final_df WHERE collagen = 1

    UNION ALL

    SELECT order_id, price, quantity, 'monk-fruit'
    FROM cleaned_final_df WHERE `monk-fruit` = 1

    UNION ALL

    SELECT order_id, price, quantity, 'oats'
    FROM cleaned_final_df WHERE oats = 1

    UNION ALL

    SELECT order_id, price, quantity, 'pea-protein'
    FROM cleaned_final_df WHERE `pea-protein` = 1

    UNION ALL

    SELECT order_id, price, quantity, 'soy'
    FROM cleaned_final_df WHERE soy = 1

    UNION ALL

    SELECT order_id, price, quantity, 'stevia'
    FROM cleaned_final_df WHERE stevia = 1

    UNION ALL

    SELECT order_id, price, quantity, 'whey'
    FROM cleaned_final_df WHERE whey = 1
) AS ingredient_data
GROUP BY ingredient
ORDER BY revenue DESC;
-- Occasioon and Ingredients Comparison/Analysis
SELECT
    occasion,
    ingredient,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS total_units,
    ROUND(SUM(price * quantity), 2) AS revenue
FROM (
    SELECT order_id, occasion, price, quantity,
           'almond-flour' AS ingredient
    FROM cleaned_final_df
    WHERE `almond-flour` = 1

    UNION ALL

    SELECT order_id, occasion, price, quantity, 'collagen'
    FROM cleaned_final_df
    WHERE collagen = 1

    UNION ALL

    SELECT order_id, occasion, price, quantity, 'monk-fruit'
    FROM cleaned_final_df
    WHERE `monk-fruit` = 1

    UNION ALL

    SELECT order_id, occasion, price, quantity, 'oats'
    FROM cleaned_final_df
    WHERE oats = 1

    UNION ALL

    SELECT order_id, occasion, price, quantity, 'pea-protein'
    FROM cleaned_final_df
    WHERE `pea-protein` = 1

    UNION ALL

    SELECT order_id, occasion, price, quantity, 'soy'
    FROM cleaned_final_df
    WHERE soy = 1

    UNION ALL

    SELECT order_id, occasion, price, quantity, 'stevia'
    FROM cleaned_final_df
    WHERE stevia = 1

    UNION ALL

    SELECT order_id, occasion, price, quantity, 'whey'
    FROM cleaned_final_df
    WHERE whey = 1
) AS ingredient_data
GROUP BY occasion, ingredient
ORDER BY occasion, revenue DESC;
-- Analysis on Income vs Ingredients tags
SELECT
    income_bracket,
    ingredient,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS total_units,
    ROUND(SUM(price * quantity), 2) AS revenue
FROM (
    SELECT order_id, income_bracket, price, quantity,
           'almond-flour' AS ingredient
    FROM cleaned_final_df
    WHERE `almond-flour` = 1

    UNION ALL

    SELECT order_id, income_bracket, price, quantity, 'collagen'
    FROM cleaned_final_df
    WHERE collagen = 1

    UNION ALL

    SELECT order_id, income_bracket, price, quantity, 'monk-fruit'
    FROM cleaned_final_df
    WHERE `monk-fruit` = 1

    UNION ALL

    SELECT order_id, income_bracket, price, quantity, 'oats'
    FROM cleaned_final_df
    WHERE oats = 1

    UNION ALL

    SELECT order_id, income_bracket, price, quantity, 'pea-protein'
    FROM cleaned_final_df
    WHERE `pea-protein` = 1

    UNION ALL

    SELECT order_id, income_bracket, price, quantity, 'soy'
    FROM cleaned_final_df
    WHERE soy = 1

    UNION ALL

    SELECT order_id, income_bracket, price, quantity, 'stevia'
    FROM cleaned_final_df
    WHERE stevia = 1

    UNION ALL

    SELECT order_id, income_bracket, price, quantity, 'whey'
    FROM cleaned_final_df
    WHERE whey = 1
) AS ingredient_data
GROUP BY income_bracket, ingredient
ORDER BY income_bracket, revenue DESC;
-- Want to see which claims most famous in different cities 
SELECT
    state,
    ingredient,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS total_units,
    ROUND(SUM(price * quantity), 2) AS revenue
FROM (
    SELECT order_id, state, price, quantity,
           'almond-flour' AS ingredient
    FROM cleaned_final_df
    WHERE `almond-flour` = 1

    UNION ALL

    SELECT order_id, state, price, quantity, 'collagen'
    FROM cleaned_final_df
    WHERE collagen = 1

    UNION ALL

    SELECT order_id, state, price, quantity, 'monk-fruit'
    FROM cleaned_final_df
    WHERE `monk-fruit` = 1

    UNION ALL

    SELECT order_id, state, price, quantity, 'oats'
    FROM cleaned_final_df
    WHERE oats = 1

    UNION ALL

    SELECT order_id, state, price, quantity, 'pea-protein'
    FROM cleaned_final_df
    WHERE `pea-protein` = 1

    UNION ALL

    SELECT order_id, state, price, quantity, 'soy'
    FROM cleaned_final_df
    WHERE soy = 1

    UNION ALL

    SELECT order_id, state, price, quantity, 'stevia'
    FROM cleaned_final_df
    WHERE stevia = 1

    UNION ALL

    SELECT order_id, state, price, quantity, 'whey'
    FROM cleaned_final_df
    WHERE whey = 1
) AS ingredient_data
GROUP BY state, ingredient
ORDER BY state, revenue DESC;