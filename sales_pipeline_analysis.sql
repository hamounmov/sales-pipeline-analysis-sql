/*
Sales Pipeline Analysis
Objective: identify what drives uneven pipeline conversion and revenue predictability
*/

--------------------------------------------------
-- 1. Baseline metrics
-- Overall closed win rate, average deal value, average time to close
--------------------------------------------------

-- Overall closed win rate

SELECT
	COUNT(*) AS total_deals,
    SUM(CASE WHEN deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS total_closed_deals,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 /
    SUM(CASE WHEN deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS win_rate
FROM sales_pipeline;


-- Average deal value

SELECT
	ROUND(AVG(close_value),2) AS avg_deal_value
FROM sales_pipeline
WHERE deal_stage IN ('Won','Lost');


-- Average time to close

SELECT
  	ROUND(AVG(close_date-engage_date),2) AS avg_time_to_close
FROM sales_pipeline
WHERE deal_stage IN ('Won','Lost');

-- Question:
-- Why it matters:

--------------------------------------------------
-- 2. Product analysis
-- Test whether closed win rate varies meaningfully by product
--------------------------------------------------

SELECT
	product,
	SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS total_won,
	COUNT(*) AS total_closed,
	ROUND(
		SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0
		/ COUNT(*)
	,2) AS win_rate
FROM sales_pipeline
WHERE deal_stage IN ('Won','Lost')
GROUP BY product;

-- Question: Does product mix explain differences in pipeline conversion?
-- Why it matters: if product-level variation is small, uneven performance is more likely driven by execution or opportunity mix.

--------------------------------------------------
-- 3. Sector analysis
-- Test whether sector explains differences in closed win rate
--------------------------------------------------

SELECT
	ac.sector,
 	COUNT(*) AS sp.total_closed,
	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS total_won,
	ROUND(
    	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0
  		/ COUNT(*)
  	,2) AS win_rate
FROM sales_pipeline sp
LEFT JOIN accounts ac
ON sp.account=ac.account
WHERE sp.deal_stage IN ('Won','Lost')
GROUP BY ac.sector
ORDER BY win_rate DESC;

-- Question:
-- Why it matters:

--------------------------------------------------
-- 4. Sales hierarchy analysis
-- Compare performance by sales agent, manager, and regional office
--------------------------------------------------


-- win rate by sales agent
SELECT
	sales_agent,
	COUNT(*) AS total_closed,
  	SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS total_won,
  	ROUND(
    	SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0
    	/ COUNT(*)
  	,2) AS win_rate
FROM sales_pipeline
WHERE sp.deal_stage IN ('Won','Lost')
GROUP BY sales_agent
ORDER BY win_rate DESC;


-- win rate by sales manager
SELECT
	st.manager,
  	COUNT(*) AS total_closed,
  	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS total_won,
  	ROUND(
    	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0
    	/ COUNT(*)
  	,2) AS win_rate
FROM sales_pipeline sp
LEFT JOIN sales_teams st
	ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage IN ('Won','Lost')
GROUP BY st.manager

	
-- win rate by regional office
SELECT
	st.regional_office,
  	COUNT(*) AS total_closed,
  	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS total_won,
  	ROUND(
    	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0
    	/ COUNT(*)
  	,2) AS win_rate
FROM sales_pipeline sp
LEFT JOIN sales_teams st
	ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage IN ('Won','Lost')
GROUP BY st.regional_office

-- Question:
-- Why it matters:
	
--------------------------------------------------
-- 5. Company size analysis
-- Test whether company segment affects win rate and may explain rep-level variation
--------------------------------------------------

-- first I will bucket the employee sizes into percentiles to get company segments

SELECT 
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY employees ASC) AS percentile_25,
	PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY employees ASC) AS percentile_50,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY employees ASC) AS percentile_75
FROM accounts;


-- using these results, I will get the win rate by company segment
	
SELECT 
	CASE 
		WHEN employees BETWEEN 0 AND 1179 THEN 'small-mid (0-1179)'
		WHEN employees BETWEEN 1180 AND 2769 THEN 'mid (1180-2769)'
		WHEN employees BETWEEN 2770 AND 5595 THEN 'upper-mid (2770-5595)'
		ELSE 'enterprise (5596+)' 
	END AS company_segment,
	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS total_won,
	COUNT(*) AS total_closed,
	ROUND(
		SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0
		/ COUNT(*)
	,2) AS win_rate
FROM accounts AS ac
INNER JOIN sales_pipeline AS sp
ON ac.account = sp.account
WHERE sp.deal_stage IN ('Won','Lost')
GROUP BY company_segment
ORDER BY win_rate DESC;

-- Question:
-- Why it matters:

--------------------------------------------------
-- 6. Opportunity mix analysis
-- Assess whether rep exposure to different company segments explains performance differences
--------------------------------------------------

