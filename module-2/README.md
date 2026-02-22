# Module 2: Subqueries & Advanced Joins (The "Complex Questions")

## **Client Request**
> "We need to dig deeper into our data. I want to know which workers have a specific skill, and I want to find our 'all-star' projects—the ones with the most workers assigned."

---

## **Part 2A: Guided Activity (Subqueries in WHERE and FROM)**

**Concept:**  
A **Subquery** is a `SELECT` statement nested inside another statement. It's powerful for answering multi-part questions.

**Guide:**  
We want to find all workers who have the skill **'Heavy Equipment Operation'** (or any other skill in your skills table).

**Multi-Step Logic:**

1. Get the `skill_id` for **'Heavy Equipment Operation'**.  
2. Get all `worker_id`s from `worker_skills` that have that `skill_id`.  
3. Fetch the worker details from the `workers` table.

**Implementation in `02_subqueries.sql`:**

- **Subquery version:** Uses a nested `SELECT` in the `WHERE` clause.  
- **JOIN version:** Uses `JOIN`s between `workers`, `worker_skills`, and `skills` for better performance.

```sql

-- Subquery version
SELECT first_name, last_name, phone
FROM workers
WHERE worker_id IN (
    SELECT worker_id
    FROM worker_skills
    WHERE skill_id = (
        SELECT skill_id FROM skills WHERE skill_name = 'Heavy Equipment Operation'
    )
);

-- JOIN version 
SELECT w.first_name, w.last_name, w.phone
FROM workers w
JOIN worker_skills ws ON w.worker_id = ws.worker_id
JOIN skills s ON ws.skill_id = s.skill_id
WHERE s.skill_name = 'Heavy Equipment Operation';



Objective:
Find the project(s) with the highest number of assigned workers. This is a "max of a count" problem.

Implementation in 02_subqueries.sql:

Uses COUNT() to count workers per project.

Uses a nested subquery in HAVING to get the maximum worker count.

Returns both project_name and worker_count for all projects that tie for the most workers.

SELECT p.project_name, COUNT(pa.worker_id) AS worker_count
FROM projects p
JOIN project_assignments pa ON p.project_id = pa.project_id
GROUP BY p.project_name
HAVING COUNT(pa.worker_id) = (
    SELECT MAX(worker_count) FROM (
        SELECT COUNT(worker_id) AS worker_count
        FROM project_assignments
        GROUP BY project_id
    ) AS subquery_max
);



Open 02_subqueries.sql in your SQL client.

Run the queries as-is to see results.

Modify the skill name in Part 2A to test different skills.

The queries return live results based on your current database content.


