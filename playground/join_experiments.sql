-- ========================================================
-- Day 1 Playground: Join Experiments
-- Run these queries sequentially to observe execution results
-- ========================================================

-- Experiment 1: INNER JOIN
-- Notice: Diana is missing because she has no orders.
SELECT c.customer_id, c.name, o.order_id, o.amount, o.status
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- Experiment 2: LEFT JOIN
-- Notice: Diana is included; order_id, amount, status are NULL for Diana.
SELECT c.customer_id, c.name, o.order_id, o.amount, o.status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Experiment 3: Anti-Join (Find customers who NEVER ordered)
-- Used in LeetCode 183!
SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Experiment 4: The ON vs WHERE Trap
-- Scenario: Find all customers and their COMPLETED orders.
-- Method A: Filtering inside ON (Correct)
SELECT c.customer_id, c.name, o.order_id, o.status
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id 
   AND o.status = 'COMPLETED';

-- Method B: Filtering inside WHERE (Flawed - drops customers without completed orders!)
SELECT c.customer_id, c.name, o.order_id, o.status
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
WHERE o.status = 'COMPLETED';

-- Experiment 5: Multi-Table Joins (Customers -> Orders -> Payments)
-- Question: Total amount paid per customer (including non-spenders with 0)
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(p.paid_amount), 0) AS total_paid
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
LEFT JOIN payments p 
    ON o.order_id = p.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_paid DESC;
