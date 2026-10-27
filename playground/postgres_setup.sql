-- ========================================================
-- Day 1 Playground: PostgreSQL Schema & Sample Data Setup
-- ========================================================

DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- 1. Customers Table (Parent)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    country VARCHAR(50)
);

-- 2. Orders Table (Child of Customers)
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL -- 'COMPLETED', 'PENDING', 'CANCELLED'
);

-- 3. Payments Table (Child of Orders)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_method VARCHAR(30) NOT NULL,
    paid_amount NUMERIC(10, 2) NOT NULL
);

-- ========================================================
-- Insert Seed Data
-- ========================================================

-- Customers: Alice (active), Bob (active), Charlie (cancelled order), Diana (no orders at all)
INSERT INTO customers (customer_id, name, country) VALUES
(1, 'Alice', 'USA'),
(2, 'Bob', 'Canada'),
(3, 'Charlie', 'UK'),
(4, 'Diana', 'USA');

-- Orders
INSERT INTO orders (order_id, customer_id, order_date, amount, status) VALUES
(101, 1, '2026-01-10', 250.00, 'COMPLETED'),
(102, 1, '2026-02-15', 80.00,  'CANCELLED'),
(103, 2, '2026-02-20', 140.00, 'COMPLETED'),
(104, 3, '2026-03-01', 310.00, 'PENDING');

-- Payments
INSERT INTO payments (payment_id, order_id, payment_method, paid_amount) VALUES
(501, 101, 'Credit Card', 250.00),
(502, 103, 'PayPal', 140.00);

SELECT 'Setup Complete! 4 customers, 4 orders, 2 payments inserted.' AS status;
