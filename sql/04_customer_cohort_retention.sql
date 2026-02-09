-- Customer Cohort Retention Analysis

-- First purchase month for each customer
WITH first_order AS (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id   
    GROUP BY c.customer_unique_id
)
SELECT 
    DATE_TRUNC('month', first_purchase_date) AS cohort_month,
    COUNT(DISTINCT customer_unique_id) AS customers_in_cohort
FROM first_order
GROUP BY cohort_month
ORDER BY cohort_month;
 

--  Customer activity by cohort and month since first purchase
WITH first_order AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),
customer_orders AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        DATE_TRUNC('month', f.first_purchase_date) AS cohort_month,
        DATE_PART(
            'month',
            AGE(
                DATE_TRUNC('month', o.order_purchase_timestamp),
                DATE_TRUNC('month', f.first_purchase_date)
            )
        ) AS months_since_first_order
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN first_order f
        ON c.customer_unique_id = f.customer_unique_id
)
SELECT
	TO_CHAR(cohort_month,'YYYY-MM') AS cohort_month,
	months_since_first_order, 
	COUNT(DISTINCT customer_unique_id) AS customers
FROM customer_orders 
GROUP BY cohort_month, months_since_first_order 
ORDER BY cohort_month, months_since_first_order;


-- Cohort retention rates relative to the first purchase month
WITH first_order AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),
customer_orders AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', f.first_purchase_date) AS cohort_month,
        DATE_PART(
            'month',
            AGE(
                DATE_TRUNC('month', o.order_purchase_timestamp),
                DATE_TRUNC('month', f.first_purchase_date)
            )
        ) AS months_since_first_order
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN first_order f
        ON c.customer_unique_id = f.customer_unique_id
),
cohort_counts AS (
    SELECT
        cohort_month,
        months_since_first_order,
        COUNT(DISTINCT customer_unique_id) AS active_customers
    FROM customer_orders
    GROUP BY cohort_month, months_since_first_order
),
cohort_size AS (
    SELECT
        cohort_month,
        active_customers AS cohort_customers
    FROM cohort_counts
    WHERE months_since_first_order = 0
)
SELECT
    c.cohort_month,
    c.months_since_first_order,
    ROUND(
        c.active_customers::NUMERIC / s.cohort_customers,
        4
    ) AS retention_rate
FROM cohort_counts c
JOIN cohort_size s
    ON c.cohort_month = s.cohort_month
ORDER BY c.cohort_month, c.months_since_first_order;
