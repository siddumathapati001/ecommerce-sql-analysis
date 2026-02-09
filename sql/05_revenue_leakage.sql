-- Revenue contribution across different order statuses
SELECT
    o.order_status,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY o.order_status
ORDER BY revenue DESC;


-- Revenue at risk from non-delivered orders
SELECT
    ROUND(SUM(p.payment_value), 2) AS revenue_at_risk
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE o.order_status <> 'delivered';


-- On-Time vs Delayed deliveries based on estimated delivery date
SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On-time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders 
WHERE order_status = 'delivered'
GROUP BY delivery_status;


-- Avarage review score from on-time vs delayed deliveries
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On-time'
        ELSE 'Delayed'
    END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_status;


-- Revenue associated with low customer review scores
SELECT
    r.review_score,
    ROUND(SUM(p.payment_value), 2) AS revenue,
	ROUND((SUM(p.payment_value))/(SELECT ROUND(SUM(payment_value), 2)
	FROM orders o
	JOIN payments p
		ON o.order_id = p.order_id
	WHERE order_status = 'delivered'), 2)*100 as percentage_share
FROM order_reviews r
JOIN orders o
    ON r.order_id = o.order_id
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY r.review_score
ORDER BY r.review_score;


-- Sellers with high share of non-delivered or delayed orders
SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.order_status <> 'delivered'
           OR o.order_delivered_customer_date > o.order_estimated_delivery_date
    ) AS problematic_orders
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT o.order_id) > 50
ORDER BY problematic_orders DESC;



