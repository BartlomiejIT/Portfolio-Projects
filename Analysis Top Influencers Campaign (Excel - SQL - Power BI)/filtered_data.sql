/* 
 - Retrieving data on influencers with the most influence in the United States,
 - Filtered by the categories Lifestyle, Fashion and Modeling.
 - Results are ordered by authentic engagement in descending order to highlight the most engaging influencers.
*/

create view project_sql_excel_power_bi.filtered_top_50_influ_by_country_and_categories as (
select
    influencer_name,
    category,
    avg_authentic_engagement,
    followers
from
    project_sql_excel_power_bi.view_influ_data_copy
where
    audience_country = 'United States'
    and (category like '%Lifestyle%' or category like '%Fashion%' or category like '%Modeling%')
order by 
    avg_authentic_engagement desc
limit 50);

-- Overview Data
select
	*
from
	project_SQL_EXCEL_POWER_BI.filtered_top_50_influ_by_country_and_categories;