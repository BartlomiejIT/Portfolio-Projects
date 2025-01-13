/*
 1. I'm gonna define the variables
 2. Create a CTE that rounds the average
 3. Select the columns that are required for the analysis
 4. Filter the results by the Influencers with the highest Authentic Engagement
 5. Order by net_profit (from highest to lowest)
*/

/* 
 -- Top 3 by Engagement Analysis
 
	-- Capmpaign Idea = Influencer Marketing
    -- The conversion rate 0.02
    -- The product cost $300
    -- The campaign cost Campaign Cost (3-month contract) $140,000 

*/ 

-- 2.
WITH top_influ_by_engagement AS (
    SELECT
        influencer_name,
        avg_authentic_engagement as AVG_Engagement_per_Post,
        Followers
    FROM
        project_SQL_EXCEL_POWER_BI.filtered_top_50_influ_by_country_and_categories
)
-- 3.
select
	influencer_name,
	avg_authentic_engagement,
	(avg_authentic_engagement * 0.02) as Potential_Units_per_Interactions,
	(avg_authentic_engagement * 0.02 * 300) as Potential_Revenue_per_Post,
	(avg_authentic_engagement * 0.02 * 300 - 140000) as Net_Profit
from
	project_sql_excel_power_bi.view_influ_data_copy
-- 4.	
where 
	Influencer_Name in ('zendaya', 'kendalljenner', 'harrystyles')
-- 5.
order by
	Net_Profit desc;


-- Top 3 by Followers Analysis

    -- Campaign Idea = Product Placement
	-- The conversion rate 0.02
	-- The product cost $300
	-- The campaign cost Campaign Cost (one-time fee) $75,000

WITH top_influ_by_followers AS (
    SELECT
        influencer_name,
        avg_authentic_engagement as AVG_Engagement_per_Post,
        Followers
    FROM
        project_SQL_EXCEL_POWER_BI.filtered_top_50_influ_by_country_and_categories
)
select
	influencer_name,
	avg_authentic_engagement,
	(avg_authentic_engagement * 0.02) as Potential_Units_per_Interactions,
	(avg_authentic_engagement * 0.02 * 300) as Potential_Revenue_per_Post,
	(avg_authentic_engagement * 0.02 * 300 - 75000) as Net_Profit
from
	project_sql_excel_power_bi.view_influ_data_copy
where 
	Influencer_Name in ('kyliejenner', 'selenagomez', 'kimkardashian')
order by
	Net_Profit desc;


-- Top 3 by Engagement Rate Analysis

   -- Campaign Idea = Sponsored Post Series
   -- The conversion rate = 0.02
   -- The product cost = $300
   -- The campaign cost (per-post) = $7,500
   -- The number of posts 11

with top_influ_by_engagement_rate as (
	SELECT
        influencer_name,
        avg_authentic_engagement as AVG_Engagement_per_Post,
        followers
    FROM
        project_SQL_EXCEL_POWER_BI.filtered_top_50_influ_by_country_and_categories
)
select
	influencer_name,
	avg_authentic_engagement,
	(avg_authentic_engagement * 0.02) as Potential_Units_per_Interactions,
	(avg_authentic_engagement * 0.02 * 300) as Potential_Revenue_per_Post,
	(avg_authentic_engagement * 0.02 * 300 - 7500) as Net_Profit_per_Post,
	((avg_authentic_engagement * 0.02 * 300 - 7500) * 11) as Total_Net_Profit
from
	project_sql_excel_power_bi.view_influ_data_copy
where 
	Influencer_Name in ('vinniehacker', 'anguscloud', 'barbieferreira')
order by
	Total_Net_Profit desc;