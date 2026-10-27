# SQL Logical Query Execution Order

When writing SQL, we write clauses in syntax order:
```sql
SELECT ... FROM ... WHERE ... GROUP BY ... HAVING ... ORDER BY ... LIMIT ...
```
However, the database engine executes clauses in a very different logical order.

---

## 1. Execution Order Diagram

```text
1. FROM & JOINs   --> Identifies source tables & joins them
2. ON             --> Evaluates join conditions
3. WHERE          --> Filters individual rows across the joined set
4. GROUP BY       --> Groups remaining rows by specified keys
5. HAVING         --> Filters grouped summary buckets
6. SELECT         --> Evaluates expressions, computes column aliases, window functions
7. DISTINCT       --> Eliminates duplicate rows from the projected set
8. ORDER BY       --> Sorts the output
9. LIMIT / OFFSET --> Takes the top N rows
```

---

## 2. Why Execution Order Matters (The 2 Big Interview Traps)

### Trap 1: Can you use a `SELECT` alias in the `WHERE` clause?
**No.** `WHERE` (step 3) runs *before* `SELECT` (step 6). The alias does not exist yet when `WHERE` executes.

```sql
-- ❌ FAILS: "revenue" does not exist in WHERE
SELECT price * quantity AS revenue
FROM sales
WHERE revenue > 1000;

-- ✅ CORRECT: Repeat expression or wrap in CTE/subquery
SELECT price * quantity AS revenue
FROM sales
WHERE (price * quantity) > 1000;
```

### Trap 2: Can you use a `SELECT` alias in the `ORDER BY` clause?
**Yes.** `ORDER BY` (step 8) runs *after* `SELECT` (step 6). The alias is fully known.

```sql
-- ✅ WORKS: "revenue" is evaluated before ORDER BY
SELECT price * quantity AS revenue
FROM sales
ORDER BY revenue DESC;
```

---

## 3. Summary Mental Model
Think of a SQL query as an assembly line:
1. Gather the raw materials (`FROM` / `JOIN`).
2. Discard defective parts early (`WHERE`).
3. Pack parts into boxes (`GROUP BY`).
4. Discard half-empty boxes (`HAVING`).
5. Label the final package (`SELECT`).
6. Remove duplicate packages (`DISTINCT`).
7. Stack packages on the shelf (`ORDER BY`).
8. Take only what fits in the delivery truck (`LIMIT`).
