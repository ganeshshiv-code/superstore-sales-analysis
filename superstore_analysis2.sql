-- How much money is the company making and how efficient is it?
select round(sum(sales),2) as total_revenue,
		round(sum(profit),2) as total_profit,
        round(sum(profit)* 100 / sum(sales),2) as profit_margin_pct
from orders;

-- Which region generates the most revenue and which is most profitable?

select region,
		round(sum(sales),2) as total_sales,
		round(sum(profit),2) as total_profit,
        round(sum(profit)/sum(sales)* 100,2) as profit_margin
from orders
group by region
order by total_sales desc;

-- Which product category is the most and least profitable?
select category, 
		round(sum(sales),2) as total_sales,
        round(sum(profit),2) as total_profit,
        round(sum(profit)/ sum(sales)* 100,2) as profit_margin
from orders
group by category
order by profit_margin desc;

-- Which sub-categories are actively losing money?
select sub_category,
		round(sum(sales),2) as total_sales,
		round(sum(profit),2) as total_profit
from orders
group by Sub_Category
order by total_profit asc;

-- Who are the most valuable customers and are they actually profitable?
select  customer_name, segment, region,
		count(distinct order_id) as total_orders,
        round(sum(sales),2) as total_sales,
        round(sum(profit),2) as total_profit
from orders
group by customer_name, segment, region
order by total_sales desc
limit 10;

-- Which category receives the most discounts — and does that explain low margins?
select category, round(avg(discount)* 100,2) as avg_discount, 
					round(sum(profit)/ sum(sales)* 100,2) as profit_margin
from orders
group by Category
order by avg_discount desc;

-- Is the business growing year over year in terms of order volume?
select year(order_date) as year, 
		count(distinct order_id) as total_order
from orders
group by year(order_date);

-- Which geographic markets are losing money despite generating sales?
select state, region,
		round(sum(sales),2) as total_sales,
		round(sum(profit),2) as total_profit
from orders
group by state, region
having total_profit < 0
order by total_profit asc;

-- 9 Which quarter is consistently the strongest and which is the weakest?
select year(order_date) as year,
		concat('Q', quarter(order_date)) as quarter,
        round(sum(sales),2) as total_sales,
        round(sum(profit),2) as total_profit
from orders
group by year, quarter
order by year, quarter;

-- Do premium ship modes actually deliver faster than standard?
select ship_mode,
		round(avg(datediff(ship_date, order_date)),2) as days
from orders
group by Ship_Mode
order by days asc;
-- At what discount level does the company start losing money?
with bucketed as (
	select order_id, sales, profit,
			case
				when discount = 0 then 'No discount'
                when discount > 0 and discount <= 0.10 then 'Low'
                when discount > 0.10 and discount <= 0.20 then 'Medium'
                when discount > 0.20 and discount <= 0.30 then 'High'
                else 'Very High'
			end as discount_bucket
		from orders
	)
    select count(distinct order_id) as total_order,
			round(sum(sales),2) as total_sales,
            round(sum(profit),2) as total_profit,
            round(sum(profit) / sum(sales) * 100 ,2) as profit_margin,
            discount_bucket
		from bucketed
	group by discount_bucket
    ORDER BY CASE
    WHEN discount_bucket = 'No Discount' THEN 1
    WHEN discount_bucket = 'Low'         THEN 2
    WHEN discount_bucket = 'Medium'      THEN 3
    WHEN discount_bucket = 'High'        THEN 4
    ELSE 5
END;

-- How many VIP customers does the company have and how many are just regular buyers?

with customer_summary as (
select customer_name, 
		count(distinct order_id) as total_order,
		round(sum(sales),2) as total_sales
	from orders
    group by customer_name
    ),
segmented as(
select customer_name, total_order, total_sales,
	case 
		when total_sales > 5000 and total_order > 5 then 'Vip'
        when total_sales > 2000 then 'Loyal'
        else 'regular'
	end as classified
from customer_summary
)
select classified, count(*) as total_customers
from segmented
group by classified;

-- What fraction of transactions are actually costing the company money?
select 
	count(case when total_profit < 0 then 1 end ) as loss_order,
    count(*) as total_order,
	round(count(case when total_profit < 0 then 1 end) * 100 / count(*),2) as order_pct
from (
	select order_id, round(sum(profit),2) as total_profit
    from orders
    group by order_id) t;
    
-- Which region-category combination is the most and least profitable?
	select region, category,
			round(sum(sales),2) as total_sales,
            round(sum(profit),2) as total_profit
	from orders
    group by region, category
    order by total_profit desc;
    
-- Is the business consistently growing month over month or are there concerning drops?
with monthly_summary as (
	select date_format(order_date, '%Y-%m') as month,
    round(sum(sales),2) as total_sales
    from orders
    group by date_format(order_date, '%Y-%m')
)
select month, total_sales, prev_sales,
		round( ( total_sales - prev_sales) * 100 / nullif(prev_sales,0),2) as mom_pct
	from (
    select 
    month, total_sales, 
		lag(total_sales) over(order by month) as prev_sales
        from monthly_summary
        ) t;
    
-- When did the business cross key revenue milestones like $1M and $2M?

select order_date, total_sales,
	round(sum(total_sales) over(order by order_date),2) as running_total
from (
	select order_date,
		round(sum(sales),2) as total_sales
	from orders
    group by order_date) t;
    
-- Which specific products should the company prioritize in each category?

with profit_order as (
	select category, product_name, 
		round(sum(profit),2) as total_profit
        from orders
		group by Category, Product_Name
),
ranked as (
select category, product_name, total_profit,
		dense_rank() over(partition by category order by total_profit desc) as rnk
from profit_order
)
select *
from ranked
where rnk <=3;
    
--  Who are the most important customers in each geographic market?

with customer_summary as (
	select customer_name, region,
		round(sum(sales),2) as total_sales
        from orders
        group by Customer_Name, region
	),
ranked as ( 
	select customer_name, region, total_sales,
    dense_rank() over(partition by region order by total_sales desc ) as rnk
    from customer_summary
)
select *
from ranked
where rnk <= 3;
    
-- Which sub-categories should be promoted and which should be discontinued?

with profit_margin as (
	select sub_category, round(sum(sales),2) as total_sales, round(sum(profit),2) as total_profit
    , round( sum(profit) * 100 / sum(sales), 2) as profit_margin
    from orders
    group by Sub_Category
)
select sub_category, total_sales, total_profit, profit_margin,
	rank() over(order by profit_margin desc) as rnk
    from profit_margin;
    
-- Are there recurring months where the business consistently loses momentum?

with monthly_summary as (
	select date_format(order_date, '%Y-%m') as month,
		round(sum(sales),2) as current_sales
        from orders
        group by date_format(order_date,'%Y-%m')
),
 prev_sales as(
select month, current_sales,
	lag(current_sales) over(order by month) as prev_sales
    from monthly_summary
    )
select * 
from prev_sales
where prev_sales is not null
and current_sales < prev_sales;

-- Who are the truly national customers buying across every region?
select customer_name 
	from orders
    group by Customer_Name
    having count(distinct region) = (select count(distinct region) from orders);
    
    
--  Which products should be featured and which should be discontinued?
	
select * from (select product_name, 
		round(sum(profit),2) as total_profit, 'Top5'as type
        from orders
        group by product_name
        order by sum(profit) desc
        limit 5) t1
        Union all
       select * from (select product_name, 
		round(sum(profit),2) as total_profit, 'Bottom 5'as type
        from orders
        group by product_name
        order by sum(profit) asc
        limit 5) t2;
        
-- How long have customers been buying and who are the longest relationships?

select customer_name, min(order_date) as first_order, 
					  max(order_date) as last_order,
					  count( distinct order_id) as total_order,
					  datediff(max(order_date), min(order_date)) as days,
					  round(sum(sales),2) as total_sales
    from orders
    group by Customer_Name
    order by total_sales desc;
    
-- Which customers are single-category buyers and could be cross-sold into new categories?
	select customer_name, min(category) as Category,
			round(sum(sales),2) as total_spending
		from orders
        group by customer_name
        having count( distinct Category) = 1;
        
-- Is the business growing in both revenue AND profitability year over year?

select year(order_date) as year,
		round(sum(sales),2) as total_sales,
        round(sum(profit),2) as total_profit,
        round(sum(profit)/sum(sales) * 100,2) as profit_margin,
        count(distinct order_id) as total_orders,
        count(distinct Customer_ID) as total_customers,
        round(sum(sales) / count(distinct order_id),2) as average_order_value
from orders
group by year(order_date);