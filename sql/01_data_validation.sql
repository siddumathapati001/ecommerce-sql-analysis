
-- Objective: Validate data integrity and basic sanity checks

-- 1. Row count per table
SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation;

-- 2. Check for null customer_id in orders
SELECT COUNT(*) AS null_customer_id_count
FROM orders
WHERE customer_id IS NULL;

-- 3. customer_id uniqueness check
SELECT customer_id, COUNT(*) FROM customers GROUP BY customer_id HAVING COUNT(*) > 1;

-- 4. order_id uniqueness check
SELECT order_id, COUNT(*) FROM orders GROUP BY order_id HAVING COUNT(*) > 1;

-- 5. product_id uniqueness check
SELECT product_id, COUNT(*) FROM products GROUP BY product_id HAVING COUNT(*) > 1;

-- 6. Check orders without payments
SELECT COUNT(*) AS orders_without_payments
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE p.order_id IS NULL;

-- 7. Check Reviews without orders
SELECT COUNT(*) AS reviews_without_orders
FROM order_reviews r
LEFT JOIN orders o ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 8. Max and Min number of items in Order
SELECT
    MIN(item_count) AS min_items,
    MAX(item_count) AS max_items,
    AVG(item_count)::NUMERIC(5,2) AS avg_items
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM order_items
    GROUP BY order_id
);

-- 9. Max and Min Payment count
SELECT
    MIN(pay_count) AS min_payments,
    MAX(pay_count) AS max_payments,
    AVG(pay_count)::NUMERIC(5,2) AS avg_payments
FROM (
    SELECT order_id, COUNT(*) AS pay_count
    FROM payments
    GROUP BY order_id
);

-- 10. Checking not delivered and not approved orders
SELECT
    COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS not_delivered,
    COUNT(*) FILTER (WHERE order_approved_at IS NULL) AS not_approved
FROM orders;

-- 11. Checking for Number of orders with and without comment
SELECT
    COUNT(*) FILTER (WHERE review_comment_message IS NULL) AS no_comment,
    COUNT(*) FILTER (WHERE review_comment_message IS NOT NULL) AS with_comment
FROM order_reviews;

-- 12. Checking for Products with and without category
SELECT total_products, with_category,
	(total_products - with_category) as without_category
FROM 
	(SELECT
    	COUNT(*) AS total_products,
    	COUNT(product_category_name) AS with_category
		FROM products);

