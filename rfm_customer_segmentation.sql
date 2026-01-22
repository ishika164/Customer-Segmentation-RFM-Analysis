CREATE DATABASE rfm_analysis;

USE rfm_analysis;

SELECT*FROM rfm_customers;


-- (1) Total customers
SELECT COUNT(DISTINCT CustomerID) AS total_customers
FROM rfm_customers;

-- (2) Average R,F,M scores
SELECT 
  ROUND(AVG(R_Score),2) AS avg_r,
  ROUND(AVG(F_Score),2) AS avg_f,
  ROUND(AVG(M_Score),2) AS avg_m
FROM rfm_customers;

-- (3) Customers per segment
SELECT Segment, COUNT(*) AS customer_count
FROM rfm_customers
GROUP BY Segment
ORDER BY customer_count DESC;

-- (4) Revenue per segment
SELECT Segment, ROUND(SUM(Monetary),2) AS total_revenue
FROM rfm_customers
GROUP BY Segment
ORDER BY total_revenue DESC;

-- (5) Average revenue per customer by segment
SELECT Segment,
       ROUND(AVG(Monetary),2) AS avg_revenue
FROM rfm_customers
GROUP BY Segment;

-- (6) Top 10 customers  by revenue
SELECT CustomerID, Monetary
FROM rfm_customers
ORDER BY Monetary DESC
LIMIT 10;

-- (7) Best customers revenue share
SELECT 
  ROUND(SUM(Monetary),2) AS best_customer_revenue
FROM rfm_customers
WHERE Segment = 'Best Customers';

-- (8) Recent but low-value customers
SELECT *
FROM rfm_customers
WHERE R_Score >= 4 AND M_Score <= 2;

-- (9) Loyal but inactive customers
SELECT *
FROM rfm_customers
WHERE F_Score >= 4 AND R_Score <= 2;

-- (10) Customers at risk
SELECT COUNT(*) AS at_risk_customers
FROM rfm_customers
WHERE R_Score <= 2 AND F_Score <= 2;

-- (11) High-value but low frequency
SELECT *
FROM rfm_customers
WHERE M_Score >= 4 AND F_Score <= 2;

-- (12) Segment percentage distribution
SELECT Segment,
       ROUND(COUNT(*) * 100.0 / 
       (SELECT COUNT(*) FROM rfm_customers),2) AS percentage
FROM rfm_customers
GROUP BY Segment;

-- (13) Average monetary value by customer segment
SELECT Segment,
       ROUND(AVG(Monetary), 2) AS avg_monetary_value
FROM rfm_customers
GROUP BY Segment
ORDER BY avg_monetary_value DESC;

-- (14) Customers contributing top 20 percent of total revenue
SELECT CustomerID, Monetary
FROM (
    SELECT CustomerID,
           Monetary,
           NTILE(5) OVER (ORDER BY Monetary DESC) AS revenue_group
    FROM rfm_customers
) t
WHERE revenue_group = 1;

-- (15) Average recency by customer segment
SELECT Segment,
       ROUND(AVG(Recency), 2) AS avg_recency
FROM rfm_customers
GROUP BY Segment
ORDER BY avg_recency;