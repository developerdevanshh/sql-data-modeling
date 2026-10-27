# SQL Joins & NULL Behavior

## 1. Join Types Quick Reference

| Join Type | Returns | When unmatched rows exist... |
|---|---|---|
| `INNER JOIN` | Only matching rows between both tables | Unmatched rows are discarded |
| `LEFT JOIN` | All rows from Left table + matching Right | Right columns become `NULL` |
| `RIGHT JOIN` | All rows from Right table + matching Left | Left columns become `NULL` |
| `FULL OUTER JOIN`| All rows from both tables | Missing side becomes `NULL` |
| `CROSS JOIN` | Cartesian product (N × M rows) | No `ON` condition required |

---

## 2. Three-Valued Logic (3VL)

In SQL, booleans can be:
- `TRUE`
- `FALSE`
- `UNKNOWN` (result of any comparison with `NULL`)

### Crucial NULL Rules:
1. `NULL = NULL` is **UNKNOWN** (not true!). Never use `=` to check for nulls.
2. Always use `IS NULL` or `IS NOT NULL`.
3. In `WHERE` filters, rows survive **only if the predicate evaluates to TRUE**. If it evaluates to `UNKNOWN`, the row is discarded.

---

## 3. The Classic Trap: `ON` vs. `WHERE` in Outer Joins

This is one of the most frequently asked interview questions.

### Scenario:
Find all customers, and include their completed orders if any.

```sql
-- ✅ CORRECT: Condition in ON
SELECT c.customer_id, c.name, o.order_id, o.status
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id 
   AND o.status = 'COMPLETED';
```
*Result*: Customers without orders (or whose orders are cancelled) **still appear**; their order columns are `NULL`.

```sql
-- ❌ BUG: Condition in WHERE
SELECT c.customer_id, c.name, o.order_id, o.status
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
WHERE o.status = 'COMPLETED';
```
*Why this fails*: For customers without completed orders, `o.status` is `NULL`. 
The filter `WHERE NULL = 'COMPLETED'` evaluates to `UNKNOWN`. 
SQL discards rows evaluating to `UNKNOWN`. 
Therefore, this query **silently behaves as an INNER JOIN** and eliminates customers without completed orders!

---

## 4. `COUNT(*)` vs `COUNT(col)` Trap

When aggregating after a `LEFT JOIN`:
- `COUNT(*)` counts every row in the output set, including rows where the right side joined with `NULL`.
- `COUNT(o.order_id)` counts only rows where `order_id` is NOT `NULL`.

Always use `COUNT(right_table.primary_key)` when counting joined child records.
