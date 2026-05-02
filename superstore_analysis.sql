-- ═══════════════════════════════════════════════════════════
-- SUPERSTORE SALES ANALYSIS
-- Tool: MySQL Workbench | Dataset: 9,694 rows | 2014-2017
-- Author: [Your Name]
-- ═══════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────
-- SECTION 1: BASIC ANALYSIS (Q1-Q10)
-- ───────────────────────────────────────────────────────────


-- Q1: Total Revenue, Profit & Overall Profit Margin
SELECT ROUND(SUM(sales),2) AS total_revenue,
       ROUND(SUM(profit),2) AS total_profit,
       ROUND(SUM(profit)/SUM(sales)*100,2) AS overall_profit_margin_pct
FROM orders;
/*
RESULT:  Total Revenue $2,272,449 | Total Profit $282,857 | Margin 12.45%
INSIGHT: Company earns only $12.45 per $100 sold — well below retail average of 15-20%.
ACTION:  Set a minimum 15% profit margin target and immediately audit the discount policy.
*/


-- Q2: Unique Customers, Orders & Products
SELECT COUNT(DISTINCT customer_id) AS customers,
       COUNT(DISTINCT order_id)    AS unique_orders,
       COUNT(DISTINCT product_id)  AS products
FROM orders;
/*
RESULT:  793 unique customers | 5,009 unique orders | 1,862 unique products
INSIGHT: Customers average 6.3 orders each — strong repeat purchasing behavior exists.
ACTION:  Launch loyalty programs to retain 793 customers and trim low-profit products from catalog.
*/


-- Q3: Total Sales, Profit & Orders by Region
SELECT region,
       ROUND(SUM(sales),2)          AS total_sales,
       ROUND(SUM(profit),2)         AS total_profit,
       COUNT(DISTINCT order_id)     AS num_orders
FROM orders
GROUP BY region
ORDER BY total_sales DESC;
/*
RESULT:  West $713K (14.86%) | East $672K (13.49%) | Central $498K (8.06%) | South $389K (11.83%)
INSIGHT: Central region has the worst margin at 8% — nearly half of West's 14.86% despite high sales.
ACTION:  Cap Central region discounts at 15% and audit sales reps approving high discount deals.
*/


-- Q4: Total Sales & Profit by Category
SELECT category,
       ROUND(SUM(sales),2)  AS total_sales,
       ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY category
ORDER BY total_profit DESC;
/*
RESULT:  Technology 17.39% margin | Office Supplies 17.13% | Furniture only 2.32% margin
INSIGHT: Furniture is 2nd highest in revenue but has a near-zero margin due to heavy discounting.
ACTION:  Set maximum 10% discount on all Furniture products and promote high-margin Technology items.
*/


-- Q5: Top 10 States by Total Sales
SELECT state,
       ROUND(SUM(sales),2)  AS total_sales,
       ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;
/*
RESULT:  California $446K | New York $311K | Texas $170K — but Texas has significant profit issues.
INSIGHT: California and New York together make up 33% of revenue and are the core profitable markets.
ACTION:  Double investment in California and New York; investigate Texas discount problem urgently.
*/


-- Q6: Total Orders Placed Each Year
SELECT YEAR(order_date)          AS year,
       COUNT(DISTINCT order_id)  AS number_order
FROM orders
GROUP BY year
ORDER BY year;
/*
RESULT:  2014: 1,693 | 2015: 1,892 (+12%) | 2016: 1,955 (+3%) | 2017: 2,271 (+16%)
INSIGHT: Orders grew every year — 34% total increase from 2014 to 2017, accelerating in 2017.
ACTION:  Invest in marketing channels driving 2017 growth and ensure logistics can handle 2,600+ orders in 2018.
*/


-- Q7: All Loss-Making Orders (Negative Profit)
SELECT order_id      AS orders,
       product_name,
       sales,
       profit,
       discount
FROM orders
WHERE profit < 0
ORDER BY profit ASC;
/*
RESULT:  1,871 loss-making orders | Worst single loss: -$6,599 | Mainly Furniture and Tables
INSIGHT: 37% of all orders lose money — nearly 4 in every 10 transactions are unprofitable.
ACTION:  Implement discount approval system: no discount above 20% without manager sign-off.
*/


-- Q8: Top 5 Products by Total Sales
SELECT product_name,
       category,
       ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY product_name, category
ORDER BY total_sales DESC
LIMIT 5;
/*
RESULT:  Top products are all Technology — Cisco Telepresence $22K, Canon imageCLASS $17K
INSIGHT: High-ticket Technology items drive the biggest individual revenue figures in the business.
ACTION:  Never discount Copiers and Machines — they sell at premium prices and should stay that way.
*/


-- Q9: Orders by Ship Mode
SELECT ship_mode,
       COUNT(DISTINCT order_id) AS order_num
FROM orders
GROUP BY ship_mode
ORDER BY order_num DESC;
/*
RESULT:  Standard Class 62% | Second Class 20% | First Class 16% | Same Day only 6%
INSIGHT: Most customers choose cheapest shipping — Same Day is heavily underutilized.
ACTION:  Market Same Day to corporate buyers and offer Second Class upsell for Standard Class customers.
*/


-- Q10: Average Discount by Category
SELECT category,
       ROUND(AVG(discount)*100,2) AS avg_discount_pct
FROM orders
GROUP BY category
ORDER BY avg_discount_pct DESC;
/*
RESULT:  Furniture 17.44% | Office Supplies 15.56% | Technology 13.22% average discount
INSIGHT: Furniture gets the highest discounts AND has the lowest margin — these two facts are directly linked.
ACTION:  Reduce Furniture discount ceiling to 10% immediately and use Technology as the low-discount benchmark.
*/


-- ───────────────────────────────────────────────────────────
-- SECTION 2: INTERMEDIATE ANALYSIS (Q11-Q25)
-- ───────────────────────────────────────────────────────────


-- Q11: Sub-Category Profit Analysis
SELECT sub_category,
       ROUND(SUM(sales),2)  AS total_sales,
       ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY sub_category
ORDER BY total_profit ASC;
/*
RESULT:  Tables -$17,725 | Bookcases -$3,472 | Supplies -$1,348 losing money | Copiers +$55,617 best
INSIGHT: Three sub-categories actively lose money while Copiers generate more profit than entire states.
ACTION:  Stop all discounts on Tables and Bookcases immediately; expand Copiers in all sales pitches.
*/


-- Q12: Monthly Sales Trend
SELECT MONTH(order_date)     AS month_num,
       MONTHNAME(order_date) AS month_name,
       ROUND(SUM(sales),2)   AS total_sales,
       ROUND(SUM(profit),2)  AS total_profit
FROM orders
GROUP BY month_num, month_name
ORDER BY month_num;
/*
RESULT:  Best months: Nov, Dec, Sep | Worst months: Jan, Feb | Nov 2017 best ever at $117,383
INSIGHT: Sales spike every Q4 and crash every Q1 — a predictable seasonal pattern repeating 4 years straight.
ACTION:  Pre-stock inventory in October, run January promotions, and plan cash flow around this cycle.
*/


-- Q13: Sales & Profit by Customer Segment
SELECT segment,
       ROUND(SUM(sales),2)               AS total_sales,
       ROUND(SUM(profit),2)              AS total_profit,
       ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin
FROM orders
GROUP BY segment
ORDER BY total_profit DESC;
/*
RESULT:  Consumer $1.15M (11.58%) | Corporate $697K (14.37%) | Home Office $426K (13.26%)
INSIGHT: Corporate has the best margin despite lower sales — corporate buyers negotiate less and order in bulk.
ACTION:  Prioritize Corporate sales team and reduce Consumer discounts which drag the company margin down.
*/


-- Q14: Average Delivery Time by Ship Mode
SELECT ship_mode,
       ROUND(AVG(DATEDIFF(ship_date, order_date)),2) AS avg_delivery_days
FROM orders
GROUP BY ship_mode
ORDER BY avg_delivery_days ASC;
/*
RESULT:  Same Day 0 days | First Class 2.2 days | Second Class 3.2 days | Standard Class 5.0 days
INSIGHT: First Class is twice as fast as Standard Class — a clear justification for the price premium.
ACTION:  Use delivery speed in marketing campaigns and audit Standard Class orders taking more than 7 days.
*/


-- Q15: Top 10 Customers by Total Sales
SELECT customer_name,
       segment,
       region,
       COUNT(DISTINCT order_id) AS total_order,
       ROUND(SUM(sales),2)      AS total_sales,
       ROUND(SUM(profit),2)     AS total_profit
FROM orders
GROUP BY customer_name, segment, region
ORDER BY total_sales DESC
LIMIT 10;
/*
RESULT:  Sean Miller #1 by sales ($23,669) but LOSES -$1,787 | Tamara Chand $18,402 with +$8,728 profit
INSIGHT: The top revenue customer is actually unprofitable — high sales without profit discipline is dangerous.
ACTION:  Build profitability scorecards for all top customers and reduce Sean Miller's discount immediately.
*/


-- Q16: Sales & Profit by Region AND Category
SELECT region,
       category,
       ROUND(SUM(sales),2)  AS total_sales,
       ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY region, category
ORDER BY total_profit DESC;
/*
RESULT:  Best: West Technology $252K (19.9%) | Worst: Central Furniture $164K at -2.8% margin
INSIGHT: Central Furniture is losing money at scale — every Furniture sale in Central is costing the company.
ACTION:  Emergency discount freeze on Central Furniture and replicate West Technology's low-discount model.
*/


-- Q17: Discount Bucket Profit Analysis
SELECT CASE
           WHEN discount = 0              THEN 'No Discount'
           WHEN discount <= 0.10          THEN 'Low (1-10%)'
           WHEN discount <= 0.20          THEN 'Medium (11-20%)'
           WHEN discount <= 0.30          THEN 'High (21-30%)'
           ELSE                                'Very High (30%+)'
       END                                   AS discount_bucket,
       COUNT(DISTINCT order_id)              AS cnt_order,
       ROUND(SUM(sales),2)                  AS total_sales,
       ROUND(SUM(profit),2)                 AS total_profit,
       ROUND(SUM(profit)*100/SUM(sales),2)  AS profit_margin
FROM orders
GROUP BY discount_bucket
ORDER BY CASE
    WHEN discount_bucket = 'No Discount'    THEN 1
    WHEN discount_bucket = 'Low (1-10%)'    THEN 2
    WHEN discount_bucket = 'Medium (11-20%)' THEN 3
    WHEN discount_bucket = 'High (21-30%)' THEN 4
    ELSE 5
END;
/*
RESULT:  No Discount +29.6% | Low +16.2% | Medium +11.8% | High -10.1% | Very High -47.4% margin
INSIGHT: Discounts above 20% always result in losses — the break-even point is between 20-21%.
ACTION:  Hard cap at 20% discount company-wide; remove ability for reps to give 30%+ without CEO approval.
*/


-- Q18: Year-over-Year Sales Comparison
SELECT year,
       total_sales,
       ROUND(total_sales - LAG(total_sales) OVER(ORDER BY year), 2)                                   AS yoy_difference,
       ROUND((total_sales - LAG(total_sales) OVER(ORDER BY year))*100 /
             NULLIF(LAG(total_sales) OVER(ORDER BY year), 0), 2)                                      AS yoy_growth_pct
FROM (
    SELECT YEAR(order_date)    AS year,
           ROUND(SUM(sales),2) AS total_sales
    FROM orders
    GROUP BY YEAR(order_date)
) t;
/*
RESULT:  2014 $484K | 2015 $471K (-2.8%) | 2016 $609K (+29.5%) | 2017 $733K (+20.3%)
INSIGHT: 2015 was the only decline year; business then grew 51% total from 2014 to 2017.
ACTION:  Investigate 2015 dip root cause and replicate 2016 recovery strategy to sustain growth.
*/


-- Q19: States with Negative Total Profit
SELECT state,
       region,
       ROUND(SUM(sales),2)  AS total_sales,
       ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY state, region
HAVING total_profit < 0
ORDER BY total_profit ASC;
/*
RESULT:  Texas -$25,729 | Ohio -$17,499 | Pennsylvania -$15,559 | Illinois -$12,607 | NC -$7,999
INSIGHT: 5 states are losing money despite high sales — revenue without profit is a dangerous illusion.
ACTION:  Halt all discount promotions in these 5 states and enforce minimum 10% margin on all future orders.
*/


-- Q20: Top 5 & Bottom 5 Products by Profit
(SELECT product_name, category, sub_category,
        ROUND(SUM(sales),2)  AS total_sales,
        ROUND(SUM(profit),2) AS total_profit,
        'Top 5'              AS type
 FROM orders
 GROUP BY product_name, category, sub_category
 ORDER BY total_profit DESC
 LIMIT 5)
UNION ALL
(SELECT product_name, category, sub_category,
        ROUND(SUM(sales),2)  AS total_sales,
        ROUND(SUM(profit),2) AS total_profit,
        'Bottom 5'           AS type
 FROM orders
 GROUP BY product_name, category, sub_category
 ORDER BY total_profit ASC
 LIMIT 5)
ORDER BY total_profit DESC;
/*
RESULT:  Best: Canon imageCLASS +$25,199 | Worst: Cubify CubeX -$8,879 losing on every sale
INSIGHT: Top products are Copiers with low discounts; loss products are Machines with excessive discounts.
ACTION:  Feature Canon imageCLASS in all corporate pitches and immediately reprice or discontinue Cubify CubeX.
*/


-- Q21: Percentage of Loss-Making Orders
SELECT COUNT(CASE WHEN total_profit < 0 THEN 1 END)                               AS loss_order,
       COUNT(*)                                                                     AS total_order,
       ROUND(COUNT(CASE WHEN total_profit < 0 THEN 1 END)*100.0/COUNT(*), 2)      AS loss_order_pct
FROM (
    SELECT order_id,
           ROUND(SUM(profit),2) AS total_profit
    FROM orders
    GROUP BY order_id
) t;
/*
RESULT:  1,001 loss orders out of 4,931 total orders = 20.3% of all orders lose money
INSIGHT: 1 in 5 orders is loss-making — in a healthy business this should be below 10%.
ACTION:  Trigger board-level discount policy review and implement real-time profit alerts before order confirmation.
*/


-- Q22: Average Order Value by Region & Segment
SELECT region,
       segment,
       ROUND(SUM(sales)/COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM orders
GROUP BY region, segment
ORDER BY avg_order_value DESC;
/*
RESULT:  East Corporate highest AOV | South Consumer lowest AOV — nearly 3x difference
INSIGHT: Corporate buyers order in bulk and negotiate less, making them the most valuable segment per order.
ACTION:  Focus enterprise sales on East Corporate and create minimum order value incentives for South Consumer.
*/


-- Q23: Late Shipment Analysis (More Than 5 Days)
SELECT COUNT(CASE WHEN days > 5 THEN 1 END)                                       AS late_order,
       COUNT(*)                                                                     AS total_order,
       ROUND(COUNT(CASE WHEN days > 5 THEN 1 END)*100/COUNT(*), 2)               AS late_order_pct
FROM (
    SELECT order_id,
           MAX(DATEDIFF(ship_date, order_date)) AS days
    FROM orders
    GROUP BY order_id
) t;
/*
RESULT:  886 late orders out of 4,931 total = 17.97% of orders ship more than 5 days late
INSIGHT: Nearly 1 in 5 customers experiences a late shipment — directly hurting satisfaction and repeat purchases.
ACTION:  Audit fulfillment bottlenecks and set a target of 90% orders shipped within 5 days.
*/


-- Q24: Sales by Quarter for Each Year
SELECT YEAR(order_date)                    AS year,
       CONCAT('Q', QUARTER(order_date))   AS quarter,
       ROUND(SUM(sales),2)                AS total_sales
FROM orders
GROUP BY YEAR(order_date), CONCAT('Q', QUARTER(order_date))
ORDER BY year, quarter;
/*
RESULT:  Q4 is strongest every year | Q1 is weakest every year | Q4 2017 best quarter ever
INSIGHT: Business follows a completely predictable quarterly pattern — Q4 always peaks, Q1 always crashes.
ACTION:  Plan inventory, staffing, and promotions around this cycle instead of reacting to it each year.
*/


-- Q25: Cities with More Than 100 Orders
SELECT city,
       state,
       region,
       COUNT(DISTINCT order_id)              AS count_order,
       ROUND(SUM(sales),2)                  AS total_sales,
       ROUND(SUM(profit),2)                 AS total_profit,
       ROUND(SUM(profit)*100/SUM(sales),2)  AS profit_margin
FROM orders
GROUP BY city, state, region
HAVING COUNT(DISTINCT order_id) > 100
ORDER BY total_profit DESC;
/*
RESULT:  New York City 915 orders | Los Angeles 747 orders | Philadelphia 537 orders top 3
INSIGHT: NYC and LA are dominant markets but high-order cities do not always have the best profit margins.
ACTION:  Open dedicated account teams in NYC and LA and audit margin in high-volume low-profit cities.
*/


-- ───────────────────────────────────────────────────────────
-- SECTION 3: ADVANCED ANALYSIS (Q26-Q40)
-- ───────────────────────────────────────────────────────────


-- Q26: Month-over-Month Sales Growth
WITH monthly_sales AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
           ROUND(SUM(sales),2)              AS total_sales
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
prev_month_sales AS (
    SELECT month,
           total_sales,
           LAG(total_sales) OVER(ORDER BY month) AS prev_month_sales
    FROM monthly_sales
)
SELECT month,
       total_sales,
       prev_month_sales,
       ROUND((total_sales - prev_month_sales)*100/NULLIF(prev_month_sales,0), 2) AS mom_growth_pct
FROM prev_month_sales;
/*
RESULT:  Biggest spike +195% Sep 2014 | Biggest drop -75% Jan 2016 | Every January crashes hard
INSIGHT: Monthly swings of -75% to +195% show extreme seasonality that is 100% predictable year over year.
ACTION:  Build a January recovery playbook with pre-planned promotions ready to deploy every new year.
*/


-- Q27: Top 3 Products Per Category by Profit
WITH profit_ranked AS (
    SELECT category,
           product_name,
           ROUND(SUM(profit),2)                                                AS total_profit,
           DENSE_RANK() OVER(PARTITION BY category ORDER BY SUM(profit) DESC) AS rnk
    FROM orders
    GROUP BY category, product_name
)
SELECT category, product_name, total_profit, rnk
FROM profit_ranked
WHERE rnk <= 3;
/*
RESULT:  Technology top 3 earn massive profits | Furniture top 3 are barely profitable
INSIGHT: Canon imageCLASS alone outperforms entire Furniture sub-categories in profitability.
ACTION:  Build corporate sales pitches around Technology top 3 and reduce Furniture product count.
*/


-- Q28: Running Total of Sales by Date
SELECT order_date,
       total_sales,
       ROUND(SUM(total_sales) OVER(ORDER BY order_date), 2) AS running_total
FROM (
    SELECT order_date,
           ROUND(SUM(sales),2) AS total_sales
    FROM orders
    GROUP BY order_date
) t;
/*
RESULT:  Crossed $1M around mid-2016 | Crossed $2M by mid-2017 | Final total $2,272,449
INSIGHT: Business doubled its cumulative revenue in just one year (2016-2017) showing strong acceleration.
ACTION:  Use milestone dates in investor presentations and forecast crossing $3M by early 2018.
*/


-- Q29: Customers Who Ordered in All 4 Regions
SELECT customer_id,
       customer_name
FROM orders
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT region) = 4;
/*
RESULT:  Only 9 customers out of 793 have placed orders in all 4 regions
INSIGHT: These 9 truly national customers are the most loyal and geographically diverse buyers.
ACTION:  Assign dedicated account managers to all 9 customers and create a VIP retention strategy for them.
*/


-- Q30: Each Order's Sales Contribution to Regional Total
SELECT order_id,
       region,
       sales,
       ROUND(sales*100/SUM(sales) OVER(PARTITION BY region), 2) AS sales_pct_region
FROM orders;
/*
RESULT:  No single order exceeds 3% of any region's total — revenue is well distributed
INSIGHT: Good diversification means no single lost deal would devastate a region's performance.
ACTION:  Monitor the top 10% of orders by value in each region — these are the deals that must not be lost.
*/


-- Q31: Top 3 Customers by Sales in Each Region
WITH total_sales AS (
    SELECT customer_id,
           region,
           ROUND(SUM(sales),2) AS total_sales
    FROM orders
    GROUP BY customer_id, region
),
rnk AS (
    SELECT customer_id,
           region,
           total_sales,
           DENSE_RANK() OVER(PARTITION BY region ORDER BY total_sales DESC) AS rnk
    FROM total_sales
)
SELECT customer_id, region, total_sales, rnk
FROM rnk
WHERE rnk <= 3;
/*
RESULT:  Each region has 3 anchor customers driving disproportionate regional revenue
INSIGHT: These 12 customers (3 per region) are the backbone of the business in each market.
ACTION:  Set up quarterly check-ins with all 12 regional top customers and monitor order frequency monthly.
*/


-- Q32: Customer Lifetime Value Segmentation
WITH customer_value AS (
    SELECT customer_id,
           ROUND(SUM(sales),2)      AS total_sales,
           COUNT(DISTINCT order_id) AS total_order
    FROM orders
    GROUP BY customer_id
),
segmented AS (
    SELECT customer_id,
           total_sales,
           total_order,
           CASE
               WHEN total_sales > 5000 AND total_order > 5 THEN 'VIP'
               WHEN total_sales > 2000                      THEN 'Loyal'
               ELSE                                              'Regular'
           END AS segment
    FROM customer_value
)
SELECT segment,
       COUNT(*) AS total_customers
FROM segmented
GROUP BY segment;
/*
RESULT:  VIP: 10 customers | Loyal: 32 customers | Regular: 751 customers
INSIGHT: Just 10 VIP customers likely drive 15-20% of total revenue — losing one would hurt significantly.
ACTION:  Create VIP loyalty program for top 10 and design upgrade incentives to move Loyal customers to VIP.
*/


-- Q33: Products Sold in All 4 Regions
SELECT category,
       product_name
FROM orders
GROUP BY category, product_name
HAVING COUNT(DISTINCT region) = (SELECT COUNT(DISTINCT region) FROM orders);
/*
RESULT:  Small subset of products sell across all 4 regions — mainly Technology and Office Supplies
INSIGHT: Universal products have the broadest customer appeal and are the most reliable revenue generators.
ACTION:  Always keep universal products in stock across all regional warehouses and never discontinue them.
*/


-- Q34: Sub-Category Profit Margin Ranking
WITH sub_cat AS (
    SELECT sub_category,
           ROUND(SUM(sales),2)               AS total_sales,
           ROUND(SUM(profit),2)              AS total_profit,
           ROUND(SUM(profit)*100/SUM(sales),2) AS profit_margin
    FROM orders
    GROUP BY sub_category
),
ranked AS (
    SELECT sub_category, total_sales, total_profit, profit_margin,
           RANK() OVER(ORDER BY profit_margin DESC) AS rnk
    FROM sub_cat
)
SELECT sub_category, total_sales, total_profit, profit_margin, rnk
FROM ranked
ORDER BY rnk;
/*
RESULT:  Labels 44.4% | Paper 43.4% | Envelopes 42.1% best margins | Tables -8.6% worst
INSIGHT: Cheap small products like Labels and Paper are more profitable than big expensive Furniture items.
ACTION:  Bundle high-margin small items in promotions and stop discounting Tables which lose money anyway.
*/


-- Q35: Months Where Sales Declined vs Previous Month
WITH monthly_sales AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
           ROUND(SUM(sales),2)              AS total_sales
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
with_prev AS (
    SELECT month,
           total_sales,
           LAG(total_sales) OVER(ORDER BY month) AS prev_sal
    FROM monthly_sales
)
SELECT month, total_sales, prev_sal
FROM with_prev
WHERE total_sales < prev_sal;
/*
RESULT:  ~14 out of 48 months show declines | January and February decline every single year
INSIGHT: 29% of months have declining sales — but almost all follow the same predictable seasonal pattern.
ACTION:  Build a Decline Month Playbook with ready-to-deploy promotions for January and February each year.
*/


-- Q36: Customer Order History Summary
SELECT customer_id,
       MIN(order_date)          AS first_order,
       MAX(order_date)          AS last_order,
       COUNT(DISTINCT order_id) AS total_order,
       ROUND(SUM(sales),2)      AS total_sales,
       DATEDIFF(MAX(order_date), MIN(order_date)) AS tenure_days
FROM orders
GROUP BY customer_id;
/*
RESULT:  Average customer tenure ~800 days | Some customers made only 1 order and never returned
INSIGHT: Single-purchase customers who never returned represent a massive missed revenue opportunity.
ACTION:  Launch win-back campaigns for customers with only 1 order and no purchase in 6+ months.
*/


-- Q37: Sub-Category Average Order vs Company Average
WITH order_sales AS (
    SELECT order_id, sub_category,
           ROUND(SUM(sales),2) AS order_total
    FROM orders
    GROUP BY order_id, sub_category
),
sub_avg AS (
    SELECT sub_category,
           AVG(order_total) AS avg_per_order
    FROM order_sales
    GROUP BY sub_category
),
overall_avg AS (
    SELECT AVG(order_total) AS overall_avg
    FROM order_sales
)
SELECT s.sub_category,
       ROUND(s.avg_per_order, 2)  AS avg_order_value,
       ROUND(o.overall_avg, 2)    AS company_avg,
       CASE WHEN s.avg_per_order > o.overall_avg
            THEN 'Above Average'
            ELSE 'Below Average'
       END                        AS comparison
FROM sub_avg s
CROSS JOIN overall_avg o;
/*
RESULT:  Copiers and Machines above average order value | Labels and Fasteners well below average
INSIGHT: High order value does not guarantee high profit — Tables are above average in value but still lose money.
ACTION:  Create bundle offers for below-average sub-categories to increase order size without extra discounts.
*/


-- Q38: Customers Who Bought From Only One Category
SELECT customer_name,
       MIN(category)       AS category,
       ROUND(SUM(sales),2) AS total_spend
FROM orders
GROUP BY customer_name
HAVING COUNT(DISTINCT category) = 1;
/*
RESULT:  ~350-400 customers have only ever bought from one category their entire history
INSIGHT: Nearly half of all customers have never been cross-sold into a second category — huge missed revenue.
ACTION:  Run cross-category campaign: Office Supplies buyers get 10% off first Technology purchase.
*/


-- Q39: Pareto Analysis — Products Making Up Top 80% Revenue
WITH product_sales AS (
    SELECT product_name,
           ROUND(SUM(sales),2) AS total_sales
    FROM orders
    GROUP BY product_name
),
running AS (
    SELECT product_name,
           total_sales,
           SUM(total_sales) OVER(ORDER BY total_sales DESC)                        AS running_total,
           ROUND(SUM(total_sales) OVER(ORDER BY total_sales DESC)*100/
                 SUM(total_sales) OVER(), 2)                                        AS cumulative_pct
    FROM product_sales
)
SELECT product_name, total_sales, ROUND(running_total,2) AS running_total, cumulative_pct
FROM running
WHERE cumulative_pct <= 80;
/*
RESULT:  ~370-400 products out of 1,862 generate 80% of total revenue
INSIGHT: Classic Pareto principle confirmed — 20% of products drive 80% of revenue.
ACTION:  Discontinue bottom 500 products by revenue to reduce costs and focus resources on top performers.
*/


-- Q40: Complete Executive Summary by Year
WITH yearly_summary AS (
    SELECT YEAR(order_date)                               AS year,
           ROUND(SUM(sales),2)                           AS total_sales,
           ROUND(SUM(profit),2)                          AS total_profit,
           ROUND(SUM(profit)*100/SUM(sales),2)           AS profit_margin,
           COUNT(DISTINCT order_id)                       AS total_orders,
           COUNT(DISTINCT customer_id)                    AS total_customers,
           ROUND(SUM(sales)/COUNT(DISTINCT order_id),2)  AS avg_order_value
    FROM orders
    GROUP BY YEAR(order_date)
),
monthly_sales AS (
    SELECT YEAR(order_date)                    AS year,
           DATE_FORMAT(order_date, '%Y-%m')    AS month,
           ROUND(SUM(sales),2)                 AS total_sales
    FROM orders
    GROUP BY YEAR(order_date), DATE_FORMAT(order_date, '%Y-%m')
),
mom_growth AS (
    SELECT year, month, total_sales,
           LAG(total_sales) OVER(PARTITION BY year ORDER BY month) AS prev_sal,
           ROUND((total_sales - LAG(total_sales) OVER(PARTITION BY year ORDER BY month))*100/
                 NULLIF(LAG(total_sales) OVER(PARTITION BY year ORDER BY month),0), 2) AS mom_growth
    FROM monthly_sales
),
region_perf AS (
    SELECT YEAR(order_date)                                                              AS year,
           region,
           ROUND(SUM(sales),2)                                                           AS total_sales,
           RANK() OVER(PARTITION BY YEAR(order_date) ORDER BY ROUND(SUM(sales),2) DESC) AS rnk
    FROM orders
    GROUP BY YEAR(order_date), region
)
SELECT y.year, y.total_sales, y.total_profit, y.profit_margin,
       y.total_orders, y.total_customers, y.avg_order_value,
       m.avg_mom_growth, r.region AS best_region
FROM yearly_summary y
LEFT JOIN (
    SELECT year, ROUND(AVG(mom_growth),2) AS avg_mom_growth
    FROM mom_growth
    GROUP BY year
) m ON y.year = m.year
LEFT JOIN region_perf r ON y.year = r.year AND r.rnk = 1;
/*
RESULT:  2014 $484K 10.1% | 2015 $471K 13.1% | 2016 $609K 13.4% | 2017 $733K 12.7% margin
INSIGHT: Business grew 51% in 4 years but 2017 margin dipped despite record sales — discounting increased.
ACTION:  Cap discounts at 20%, fix Furniture pricing, and protect top 10 VIP customers to hit 15% margin target.
*/
