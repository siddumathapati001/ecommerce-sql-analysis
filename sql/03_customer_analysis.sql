-- How many orders does a typical customer place, and How skewed is repeat behavior
-- Analyze distribution of order counts per unique customer
WITH orders_per_customer AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    order_count,
    COUNT(customer_unique_id) AS customer_count
FROM orders_per_customer
GROUP BY order_count
ORDER BY order_count;

-- What percentage of customers are one-time vs repeat buyers?
WITH orders_per_customer AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),
Total_unique_customers AS (
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count,
	  ROUND(
        100.0 * COUNT(*) / (SELECT total_customers FROM total_unique_customers),
        2
    ) AS percentage_share
FROM orders_per_customer
GROUP BY customer_type;

-- Revenue contribution from one-time and repeat customers
WITH orders_per_customer AS (
	SELECT c.customer_unique_id, 
		COUNT(o.order_id) AS number_of_orders
	FROM customers c 
	JOIN orders o
		ON c.customer_id = o.customer_id
	GROUP BY customer_unique_id
),
revenue_per_customer AS (
	SELECT c.customer_unique_id,
		SUM(p.payment_value) AS revenue_generated
	FROM customers c 
	JOIN orders o
		ON c.customer_id = o.customer_id
	JOIN payments p
		ON o.order_id = p.order_id
	GROUP BY customer_unique_id
),
total_revenue AS (
	SELECT SUM(payment_value) AS revenue FROM payments
)
SELECT 
	CASE 
		WHEN number_of_orders = 1 THEN 'one_time'
		ELSE 'repeat'
	END AS customer_type,
	SUM(revenue_generated) AS Total_revenue_genereted,
	ROUND(
		100.0 * SUM(revenue_generated) / (SELECT revenue FROM total_revenue), 2
	) AS Percentage_share_Revenue
	FROM orders_per_customer o
	JOIN revenue_per_customer r
		ON o.customer_unique_id = r.customer_unique_id
	GROUP BY customer_type
	ORDER BY percentage_share_revenue DESC;

-- Average revenue generated per unique customer
WITH revenue_per_customer AS (
    SELECT c.customer_unique_id,
        SUM(p.payment_value) AS revenue_generated
    FROM customers c 
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY customer_unique_id
)
SELECT
    ROUND(AVG(revenue_generated), 2) AS avg_revenue_per_customer
FROM revenue_per_customer;

-- Monthly active purchasing customers
SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT c.customer_unique_id) AS active_purchasing_customers
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY month
ORDER BY month;
