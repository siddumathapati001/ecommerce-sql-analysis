-- schema.sql
-- Database: ecommerce_sql_analysis
-- Dataset: Olist E-Commerce
-- Purpose: Document table structure and relationships

-- ======================
-- TABLE: customers
-- ======================
-- customer_id (PK)
-- customer_unique_id
-- customer_zip_code_prefix
-- customer_city
-- customer_state
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- ======================
-- TABLE: orders
-- ======================
-- order_id (PK)
-- customer_id (FK → customers.customer_id)
-- order_status
-- order_purchase_timestamp
-- order_approved_at
-- order_delivered_customer_date
-- order_estimated_delivery_date
-- order_delivered_carrier_date
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- ======================
-- TABLE: order_items
-- ======================
-- order_id (FK → orders.order_id)
-- order_item_id
-- product_id
-- seller_id
-- shipping_limit_date
-- price
-- freight_value
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT fk_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ======================
-- TABLE: payments
-- ======================
-- order_id (FK → orders.order_id)
-- payment_sequential
-- payment_type
-- payment_installments
-- payment_value
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value NUMERIC(10,2),
    CONSTRAINT pk_payments PRIMARY KEY (order_id, payment_sequential),
    CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ======================
-- TABLE: order_reviews
-- ======================
-- review_id
-- order_id (FK → orders.order_id)
-- review_score
-- review_comment_title
-- review_comment_message
-- review_creation_date
-- review_answer_timestamp
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50) NOT NULL,
    review_score INTEGER CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    CONSTRAINT fk_reviews_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- ======================
-- TABLE: products
-- ======================
-- product_id (PK)
-- product_category_name
-- product_name_lenght
-- product_description_lenght
-- product_photos_qty
-- product_weight_g
-- product_length_cm
-- product_height_cm
-- product_width_cm
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INTEGER CHECK (product_name_lenght >= 0),
    product_description_lenght INTEGER CHECK (product_description_lenght >= 0),
    product_photos_qty INTEGER CHECK (product_photos_qty >= 0),
    product_weight_g INTEGER CHECK (product_weight_g >= 0),
    product_length_cm INTEGER CHECK (product_length_cm >= 0),
    product_height_cm INTEGER CHECK (product_height_cm >= 0),
    product_width_cm INTEGER CHECK (product_width_cm >= 0)
);

-- ===============================================
-- TABLE: product_category_name_translation
-- ===============================================
-- product_category_name (PK)
-- product_category_name_english
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100) NOT NULL
);

-- ======================
-- TABLE: sellers
-- ======================
-- seller_id (PK)
-- seller_zip_code_prefix
-- seller_city
-- seller_state
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INTEGER,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- ======================
-- TABLE: geolocation
-- ======================
-- geolocation_zip_code_prefix
-- geolocation_lat
-- geolocation_lng
-- geolocation_city
-- geolocation_state
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);