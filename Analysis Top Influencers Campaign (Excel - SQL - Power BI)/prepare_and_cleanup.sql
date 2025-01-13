create schema project_sql_excel_power_bi;

create table project_sql_excel_power_bi.top_1000_influencers(
    name VARCHAR(50),
    rank INT,
    category VARCHAR(255),
    audience_country VARCHAR(50),
    followers_as_num INT,
    authentic_engagement_as_num NUMERIC,
    engagement_avg_as_num NUMERIC
);
-- Import Data of "top_1000_influencers" from my "csv_file" to "top_1000_influencers" table.

-- Overview Data
select * from project_sql_excel_power_bi.top_1000_influencers;

-- Create View 
create view project_sql_excel_power_bi.view_influ_data as (
	select
		name as influencer_name,
		rank,
		category,
		audience_country,
		followers_as_num as followers,
		authentic_engagement_as_num as avg_authentic_engagement,
		engagement_avg_as_num as avg_engagement
	from 
		project_sql_excel_power_bi.top_1000_influencers
);

-- Overview Data
select * from view_influ_Data;

-- Count the total number of records (or rows) are in the SQL view
select
    COUNT(*) AS no_of_rows
from
    project_sql_excel_power_bi.view_influ_data;
   
-- Count the total number of columns (or fields) are in the SQL view
select
    count(*) as column_count
from
    information_schema.columns
where
    table_name = 'view_influ_data'
   	and table_schema = 'project_sql_excel_power_bi';

-- Check the data types of each column from the view by checking the INFORMATION SCHEMA view
select
    COLUMN_NAME,
    DATA_TYPE
from
    INFORMATION_SCHEMA.columns
where
    TABLE_NAME = 'view_influ_data';
   
-- Check missing values
select COUNT(*) AS empty_values_count
from project_sql_excel_power_bi.view_influ_data
where category = '';
 
-- Check values equal to "0"
select COUNT(*) AS zero_value_count
from project_sql_excel_power_bi.view_influ_data
where avg_authentic_engagement = 0;

 /*
# 1. Check for duplicate rows in the view
# 2. Group by the influencer_name
# 3. Filter for groups with more than one row
*/

 --1.
 SELECT
     influencer_name,
     COUNT(*) AS duplicate_count
 FROM
     project_sql_excel_power_bi.view_influ_data
 --2.
 GROUP BY
     influencer_name
 --3.
 HAVING
     COUNT(*) > 1;
    
--         
SELECT 
	COUNT(*) - COUNT(distinct influencer_name) as total_duplicates
FROM 
    project_sql_excel_power_bi.view_influ_data;

    
-- We can see that we have 38 duplicates in the "name" column.

/*
- Create CTE and then now I want to delete the rows where the same name value appears again, but keep the first one.
- Also delete missing values like '' and records where value of avg_authentic_engagement is equal 0.
- First I would like to do it on copy of our view table  
*/

create table project_sql_excel_power_bi.view_influ_data_copy as (
select
	* 
from 
	project_sql_excel_power_bi.view_influ_data
);

-- Create Common Table Expression to give row numbers
-- Remove duplicates rows and missing values
with no_duplicates_and_missing_values as (
    select 
        ctid,
        ROW_NUMBER() over (PARTITION BY influencer_name ORDER BY rank) as rn
    from 
        project_sql_excel_power_bi.view_influ_data_copy
)
delete from project_sql_excel_power_bi.view_influ_data_copy
where ctid in (
    select
    	ctid
    from
    	no_duplicates_and_missing_values
    where
    	rn > 1
        or category = ''
        or avg_authentic_engagement = 0
);

-- Check how many rows I have now
select 
    COUNT(*) AS no_of_rows
from
	project_sql_excel_power_bi.view_influ_data_copy;

-- Overview data
select * from project_sql_excel_power_bi.view_influ_data_copy;
   
