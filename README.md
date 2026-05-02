# Superstore Sales Analysis — Key Insights

## Project Overview
Analyzed 9,694 orders from a US retail company (2014–2017) using MySQL.
Found critical insights on revenue, profitability, discounting, and customer behavior.

---

## Key Business Findings

### 1. Company is Below Industry Average on Profit
- Total Revenue: **$2,272,449** | Total Profit: **$282,857** | Margin: **12.45%**
- Retail industry average margin is 15–20% — Superstore is significantly below
- Root cause: excessive discounting across all categories

### 2. Discounting is Destroying Profit
- Orders with **no discount** → **+29.6% margin**
- Orders with **20–30% discount** → **-10.1% margin** (losing money)
- Orders with **30%+ discount** → **-47.4% margin** (losing $47 per $100 sold)
- The break-even point is between 20–21% discount
- **Recommendation: Hard cap all discounts at 20%**

### 3. Furniture Category is a Crisis
- Furniture is 2nd highest in revenue ($733K) but has only **2.32% profit margin**
- Tables sub-category alone loses **-$17,725** annually with 26% average discount
- Bookcases also losing **-$3,472** every year
- Meanwhile Labels (44%) and Paper (43%) have the highest margins in the company
- **Recommendation: Cap Furniture discounts at 10% immediately**

### 4. Central Region and Key States are Losing Money
- Central region has only **8.06% margin** — half of West's 14.86%
- 5 states have negative total profit: Texas (-$25,729), Ohio (-$17,499), Pennsylvania (-$15,559)
- These states are generating revenue but losing money on every deal
- **Recommendation: Freeze all discounts in loss-making states**

### 5. Top Customer by Revenue is Actually Unprofitable
- Sean Miller is #1 customer by sales ($23,669) but generates a **loss of -$1,787**
- Reason: 27.5% average discount on all his orders
- Tamara Chand ($18,402 sales, +$8,728 profit) is the truly best customer
- Only **10 customers** qualify as VIP out of 793 total
- **Recommendation: Measure customers by profit not just revenue**

### 6. Business is Growing but Needs Margin Discipline
- Orders grew 34% from 2014 to 2017 (1,693 → 2,271 orders per year)
- Revenue grew 51% over 4 years — healthy trajectory
- Q4 is consistently the strongest quarter every year — November always peaks
- January consistently drops 54–75% after December — predictable seasonal pattern
- **Recommendation: Plan inventory and promotions around this seasonal cycle**

---

## SQL Concepts Used
- Window Functions: `LAG()`, `DENSE_RANK()`, `RANK()`, `SUM() OVER()`
- CTEs (Common Table Expressions)
- Subqueries and correlated subqueries
- `CASE WHEN` for bucketing and segmentation
- `UNION ALL` for combining result sets
- Date functions: `YEAR()`, `MONTH()`, `QUARTER()`, `DATEDIFF()`
- Aggregate functions with `GROUP BY`, `HAVING`, `COUNT(DISTINCT)`

---

## Files
| File | Description |
|------|-------------|
| `superstore_analysis.sql` | All 25 SQL queries with comments |
| `insights.md` | Key business findings and recommendations |

---

## Dataset
- Source: Sample Superstore (available on Kaggle)
- Rows: 9,694 orders
- Period: 2014–2017
- Tool: MySQL Workbench
