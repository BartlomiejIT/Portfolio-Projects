-- Monday Coffee -- Exploratory Data Analysis

-- Overview data

select * from city;

select * from products;

select * from customers;

select * from sales;

-- Count rows

select count(*) as "num of rows from city table" from city;

select count(*) as "num of rows from customers table" from customers;

select count(*) as "num of rows from sales table" from sales;

-- Missing Values

SELECT
    count(*)
FROM
    city
WHERE city_id IS NULL or city_name = '' or population IS NULL or estimated_rent IS NULL or city_rank is NULL;

SELECT
    count(*)
FROM
    customers
WHERE city_id IS NULL or customer_id IS NULL or customer_name = '' or city_id IS NULL;

SELECT
    count(*)
FROM
    sales
WHERE sale_id IS NULL or sale_date IS NULL or product_id IS NULL or customer_id IS NULL or total IS NULL or rating IS NULL;

-- Duplicates

select *, count(*) 
from city 
group by city_id, city_name, population, estimated_rent, city_rank  
having count(*) > 1;

select *, count(*)
from customers
group by customer_id, customer_name, city_id
having count(*) > 1;

select *, count(*)
from sales
group by sale_id, sale_date, product_id, customer_id, total, rating
having count(*) >1;

-- Reports Data Analysis

-- 1. Total Revenue from Coffee sales

select
    city.city_name as city,
    sum(sales.total) as "total revenue"
from sales
join customers on sales. customer_id = customers. customer_id
join city on customers. city_id = city. city_id
group by 1
order by 2 desc;

-- 2. Avg Sale per Customer in each City

select
    city. city_name as city,
    sum(sales. total) as "total revenue",
    count(distinct(customers. customer_id)) as "total customers",
    round((sum(sales. total) / count(distinct(customers. customer_id)))::numeric, 2) as "average sale per customer"
from sales
join customers on sales. customer_id = customers. customer_id
join city on city. city_id = customers. city_id
group by 1
order by 4 desc;

-- 3. Each city and their average rent per customer

with city_table as (
    select
        city. city_name,
        city. population,
        SUM (sales. total) as total_revenue,
        COUNT (DISTINCT sales. customer_id) as total_cx,
        ROUND ( SUM (sales. total):: numeric / COUNT (DISTINCT sales. customer_id):: numeric , 2) as avg_sale_pr_cx
    from
        sales
    join
        customers on sales. customer_id = customers. customer_id
    join city on city .city_id = customers .city_id
    group by 1, 2
    order by 3 desc
),
city_rent as (
    select
        city_name,
        population,
        estimated_rent
    from city
)
select
    city_rent. city_name as city,
    city_rent. estimated_rent as "estimated rent",
    round((city_rent. estimated_rent / city_table. total_cx):: numeric, 2) as "avg rent per customer",
    round(city_rent. population / 1000000, 2) as "population in millions"
from city_rent
join city_table on city_rent. city_name = city_table. city_name
order by 3 asc;

-- 4. Number of unique customers there are in each city who have purchased coffee products:

select
    city. city_name as city,
    count(distinct customers. customer_id)
from
    customers
join city on city. city_id = customers. city_id
group by 1
order by 2 desc;

-- 5. Number of people in each city are estimated to consume coffee, given that 25% of the population:

select 
    city. city_name AS city,
    ROUND ((city. population * 0.25) / 1000000, 2) as "coffee consumers (in millions)",
    COUNT (distinct customers. customer_id) as "count of customers"
from customers
join city on city.city_id = customers.city_id
group by 1, 2
order by 2 desc;

-- 6. Identify top 3 cities based on highest sales, city name, total sale, total rent, total customers, estimated coffee consumers

with city_table as 
    (
    SELECT
        city.city_name,
        SUM(sales. total) as total_revenue,
        COUNT (DISTINCT sales. customer_id) as total_cx,
        ROUND ((SUM (sales. total) / COUNT (DISTINCT sales. customer_id)):: numeric, 2) as avg_sale_pr_cx
    from
        sales 
    JOIN customers on sales. customer_id = customers. customer_id
    JOIN city on city. city_id = customers. city_id
    group by 1
    order by 2 desc
),
city_rent as (
    SELECT
        city_name,
        estimated_rent,
        round((population * 0.25) / 1000000 :: numeric, 3) as estimated_coffee_consumer_in_millions
    from
        city
)
select 
    cr. city_name as city,
    total_revenue as "total revenue",
    cr. estimated_rent as "total rent",
    ct. total_cx as "total customers",
    estimated_coffee_consumer_in_millions as "estimated consumers (millions)",
    ct. avg_sale_pr_cx as "avg sale per customer",
    round((cr.estimated_rent / ct. total_cx):: numeric, 2) as "avg rent per"
    from city_rent as cr
    join city_table as ct on cr. city_name = ct. city_name
    order by 2 desc;

