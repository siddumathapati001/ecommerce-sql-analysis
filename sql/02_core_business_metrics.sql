-- Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Total delivered orders
SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';

-- Total revenue (based on payments)
SELECT SUM(payment_value) AS total_revenue
FROM payments;

-- Average Order Value (AOV) for delivered orders
SELECT
    SUM(p.payment_value) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';


-- Time Coverage of the Dataset, Identifies the Analysis period
SELECT
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date
FROM orders;

-- Total Orders and Delivered and Not Delivered Orders
SELECT 
	COUNT(*) AS Total_orders,
	COUNT(*) FILTER (WHERE order_status = 'delivered') AS delivered_orders,
	COUNT(*) FILTER (WHERE order_status <> 'delivered') AS non_delivered_orders
FROM orders;

-- Total Revenue Collected based on actual Payment values
SELECT 
	ROUND(SUM(payment_value)::NUMERIC,2) AS total_revenue
FROM payments;

-- Average revenue generated per Order
SELECT
	ROUND(SUM(payment_value)/COUNT(DISTINCT order_id),2) AS avg_order_value
FROM payments;

SELECT
    ROUND(AVG(order_count)::NUMERIC, 2) AS avg_orders_per_customer
FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
);

-- Average orders per customer
SELECT
    ROUND(AVG(order_count)::NUMERIC, 2) AS avg_orders_per_customer
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM orders o 
	JOIN customers c 
	ON o.customer_id = c.customer_id
    GROUP BY customer_unique_id
);

-- Distribution of Payment Installments
SELECT
    payment_installments,
    COUNT(*) AS transactions
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- Revenue Contribution by Order Status
SELECT 
	o.order_status,
	ROUND(SUM(p.payment_value)::NUMERIC,2) AS revenue
FROM orders o
JOIN payments p 
	ON o.order_id = p.order_id
GROUP BY o.order_status
ORDER BY revenue DESC;

-- Monthly Revenue trend and Active Purchasing Customers
SELECT 
	DATE_TRUNC('month',o.order_purchase_timestamp) AS month,
	ROUND(SUM(p.payment_value)::NUMERIC,2) AS monthly_revenue,
	COUNT(c.customer_unique_id) AS active_purchasing_customers
FROM orders o
JOIN payments p
	ON o.order_id = p.order_id
JOIN customers c
	ON o.customer_id = c.customer_id
GROUP BY month
ORDER BY month;
