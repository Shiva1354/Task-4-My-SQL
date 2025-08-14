CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_name VARCHAR(100),
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO customers (name, email, country) VALUES
('Alice Johnson', 'alice@example.com', 'USA'),
('Bob Smith', 'bob@example.com', 'Canada'),
('Charlie Lee', 'charlie@example.com', 'UK');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-08-01', 150.50),
(2, '2025-08-02', 250.00),
(3, '2025-08-03', 99.99),
(1, '2025-08-04', 300.00);

INSERT INTO order_items (order_id, product_name, quantity, price) VALUES
(1, 'Laptop', 1, 150.50),
(2, 'Phone', 1, 250.00),
(3, 'Headphones', 2, 49.99),
(4, 'Tablet', 1, 300.00);

-- Basic queries
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM orders WHERE total_amount > 200;
SELECT * FROM orders ORDER BY total_amount DESC;
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id;

-- JOIN queries
SELECT o.order_id, c.name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

SELECT c.customer_id, c.name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

SELECT c.customer_id, c.name, o.order_id, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- Aggregate functions
SELECT SUM(total_amount) AS total_revenue FROM orders;
SELECT AVG(total_amount) AS avg_order_value FROM orders;

-- Subquery
SELECT name, country
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (SELECT AVG(total_amount) FROM orders)
);

-- View
DROP VIEW IF EXISTS customer_orders;
CREATE VIEW customer_orders AS
SELECT o.order_id, c.name AS customer_name, o.order_date, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT * FROM customer_orders;

-- Index
CREATE INDEX idx_customer_id ON orders(customer_id);
SHOW INDEXES FROM orders;
