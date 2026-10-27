-- Problem: LeetCode 183 - Customers Who Never Order
-- Level: Easy
-- Link: https://leetcode.com/problems/customers-who-never-order/
-- Topic: Anti-Join (LEFT JOIN ... WHERE right IS NULL) vs NOT EXISTS

/*
Table: Customers
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key column for this table.

Table: Orders
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| customerId  | int     |
+-------------+---------+
id is the primary key column for this table.
customerId is a foreign key of the ID from the Customers table.

Task:
Write a solution to find all customers who never order anything.
*/

-- Approach 1: Anti-Join using LEFT JOIN + WHERE IS NULL (Recommended for Day 1)
SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o 
    ON c.id = o.customerId
WHERE o.customerId IS NULL;

-- Approach 2: Subquery using NOT EXISTS
-- Often faster on large datasets because it can short-circuit upon finding the first match
/*
SELECT c.name AS Customers
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM Orders o 
    WHERE o.customerId = c.id
);
*/

-- Approach 3: NOT IN (Caution with NULLs!)
-- If Orders.customerId contains ANY NULL value, "NOT IN" returns zero rows because
-- UNKNOWN logic breaks the condition. Always prefer LEFT JOIN or NOT EXISTS over NOT IN.
