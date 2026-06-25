use protfolio;
select * from final_project_new;
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
COUNT(*) AS orders,ROUND(SUM(total_price),2) AS revenue
FROM final_project_new GROUP BY price_range ORDER BY MIN(price);-- after 10-20 orders and revenue drop significantly
SELECT
persona,
ROUND(AVG(price),2) avg_price,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY persona;-- likely in all persona all are equaly tipe nits solds,reveneu generate
SELECT
persona,
CASE
    WHEN price<10 THEN '0-10'
    WHEN price<20 THEN '10-20'
    WHEN price<30 THEN '20-30'
    WHEN price<40 THEN '30-40'
    ELSE '40+'
END price_band,SUM(quantity) units
,ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY persona,price_band;-- in all section in price 20-30 range revenue and units sold drop significantly
SELECT
category,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY category ORDER BY revenue DESC;-- Protien Shake generate most revenue,Healthy snake and Electrolyte drink less
SELECT
season,ROUND(AVG(price),2) avg_price,
SUM(quantity) units,ROUND(SUM(total_price),2) revenue
FROM final_project_new GROUP BY season;-- although all season generate equaly likely revenue but in summer more unit sells
SELECT
channel,
ROUND(AVG(price),2) avg_price,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY channel;-- Gym Kisok are most reveneu generater and from website all less ,avarage,units sold,revenue
SELECT
age_group,
ROUND(AVG(price),2) avg_price,
SUM(quantity) units,ROUND(SUM(total_price),2) revenue
FROM final_project_new GROUP BY age_group;-- Nothing new pattern to be observed here
SELECT
dietary_restriction,
ROUND(AVG(price),2) avg_price,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY dietary_restriction;-- firstly No diatary_restriction persons are most revenue generate,2ndly vegan and vegeterian people
SELECT
occasion,
SUM(quantity) units,ROUND(SUM(total_price),2) revenue
FROM final_project_new GROUP BY occasion;-- most revenue came from late night orders and less from road trip
SELECT
pack_size,
ROUND(AVG(price),2) avg_price,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY pack_size;-- pack size increaase-->revenue increase
SELECT
claims,
ROUND(AVG(price),2) avg_price,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY claims;-- vegan and high-protien foods generate most revenue and low-sugar+clean-label food combination generate most
SELECT
trend_affinity,
ROUND(AVG(price),2) avg_price,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY trend_affinity;-- almost all geneerete eqully likely revenue but gut-health base are slightly less 

-- 	PHASE 2
SELECT
state,
ROUND(AVG(price),2) avg_price,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY state ORDER BY revenue DESC;-- California generate most revenue but Washington has highest avrage spending
SELECT
city_tier,
ROUND(AVG(price),2) avg_price,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY city_tier;-- as usual tier citys spending low-->high but in tier 2 has highest avarage
SELECT
state,
city_tier,
SUM(quantity) units,ROUND(SUM(total_price),2) revenue
FROM final_project_new GROUP BY state,city_tier;-- in all state habe same pattern like tier 1,2,3-->big-->small revinue but in Washingon Tier2 city generate more revenue
SELECT
state,
occasion,
SUM(quantity) units,ROUND(SUM(total_price),2) revenue
FROM final_project_new GROUP BY state,occasion;-- all have get more revenue from late night but in florida it is came from Relegious fasting
SELECT
state,
ROUND(AVG(price),2) avg_price,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
WHERE persona='Premium'
GROUP BY state;-- premium member generate more revenue at California and in Illinois most avrage spending
SELECT
state,category,
SUM(quantity) units,ROUND(SUM(total_price),2) revenue
FROM final_project_new GROUP BY state,category;-- in every state protien shake is most demanding and high reveneue genaretor
UPDATE final_project_new
SET category = 'Protein Bar'
WHERE TRIM(LOWER(category)) = 'protein bar';
SELECT
season,
category,SUM(quantity) units,ROUND(SUM(total_price),2) revenue
FROM final_project_new
GROUP BY season,category;-- in spring Meal Replacement,Autumn Protien Shake,and remaining two season protien bar generate most revenue
SELECT
persona,
category,SUM(quantity) units,
ROUND(SUM(total_price),2) revenue FROM final_project_new
GROUP BY persona,category;-- fitness person-->meal replacement and remainiing all generate most revenue from protien bar 
SELECT
state,
city_tier,occasion,ROUND(AVG(price),2) avg_price,
SUM(quantity) total_units,
ROUND(SUM(total_price),2) revenue,
ROUND(
SUM(total_price)/SUM(quantity),2
) revenue_per_unit
FROM final_project_new GROUP BY state,city_tier,occasion
ORDER BY revenue DESC;-- overall survey
SELECT
category,
persona,season,
ROUND(SUM(total_price),2) revenue
FROM final_project_new GROUP BY category,persona,season
ORDER BY revenue DESC LIMIT 20;-- MOst revenue generated combination
SELECT
state,
city_tier,occasion,persona,ROUND(AVG(price),2) avg_price,
SUM(quantity) units,ROUND(SUM(total_price),2) revenue
FROM final_project_new GROUP BY state,city_tier,occasion,persona
ORDER BY revenue DESC;-- Another good combination survey
