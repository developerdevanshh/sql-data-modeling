-- Problem: LeetCode 1378 - Replace Employee ID With The Unique Identifier
-- Level: Easy
-- Link: https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/
-- Topic: Master table preservation with NULL fallback

/*
Table: Employees
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.

Table: EmployeeUNI
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| unique_id     | int     |
+---------------+---------+
(id, unique_id) is the primary key for this table.

Task:
Write a solution to show the unique ID of each user, If a user does not have a 
unique ID replace just show null.
*/

-- Solution:
SELECT 
    u.unique_id,
    e.name
FROM Employees e
LEFT JOIN EmployeeUNI u 
    ON e.id = u.id;

-- Takeaway:
-- In LEFT JOIN, table order matters:
-- Left table (Employees) keeps all rows.
-- Right table (EmployeeUNI) supplies unique_id where matched, and fills NULL where not.
