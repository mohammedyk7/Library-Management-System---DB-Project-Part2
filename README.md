
# 📚 Library Management System — SQL Project

This project simulates the backend of a real-world library system using SQL Server.
It includes fully normalized tables, SELECT queries, stored procedures, views, functions, triggers, and transactional logic.

---

## ✅ Project Contents

- `SELECT Queries`: 20+ practical queries simulating API endpoints
- `Indexes`: Performance-enhancing nonclustered indexes
- `Views`: Ready-to-query dashboards and reports
- `Functions`: Scalar and table-valued for reuse and logic encapsulation
- `Stored Procedures`: Reusable business tasks (e.g., book borrow, return)
- `Triggers`: Automation on insert/update for consistency
- `Aggregations`: Dashboard and analytics queries
- `Transactions`: Safe, multi-step business logic blocks

---

## 🧠 Key Concepts Demonstrated

- JOINs and subqueries
- GROUP BY and HAVING
- Error handling in transactions
- Trigger-based automation
- Functions for logic reuse
- Real-world scenarios modeled in SQL

---

## Sample Use Cases

- Track overdue loans and fines
- Show top-rated and most borrowed books
- Calculate library revenue
- Validate and auto-enforce business rules (via triggers)
- Safely update multiple tables using transactions

---

## How to Run

1. Restore the database or create the schema manually.
2. Execute files in this order:
   - `Tables & Seed Data`
   - `Indexes.sql`
   - `Functions.sql`
   - `Views.sql`
   - `StoredProcedures.sql`
   - `Triggers.sql`
   - Run `SELECT`, `Aggregations`, or `Transactions` as needed.

---

## Developer Reflection

>  *What part was hardest and why?*  
Designing complex triggers and ensuring safe multi-table updates in transactions was the most challenging part. Especially debugging WHEN and INSTEAD OF triggers.

>  *Which concept helped you think like a backend developer?*  
Functions and stored procedures taught the value of separating logic from queries. Also, writing atomic transactions builds confidence in error handling.

>  *How would you test this if it were a live web app?*  
I'd simulate realistic flows:
- Borrow and return books
- Pay fines and verify revenue update
- Use frontend forms to call stored procedures
- Write integration tests for data consistency after triggers fire

---



