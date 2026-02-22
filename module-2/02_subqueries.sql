-- Module 2: Subqueries & Advanced Joins

-- Part 2A: Find Workers by Skill

-- Option 1: Using a subquery in the WHERE clause
SELECT first_name, last_name, phone
FROM workers
WHERE worker_id IN (
    SELECT worker_id
    FROM worker_skills
    WHERE skill_id = (
        SELECT skill_id 
        FROM skills 
        WHERE skill_name = 'Heavy Equipment Operation'
    )
);


-- Option 2: Using JOINs

SELECT w.first_name, w.last_name, w.phone
FROM workers w
JOIN worker_skills ws ON w.worker_id = ws.worker_id
JOIN skills s ON ws.skill_id = s.skill_id
WHERE s.skill_name = 'Heavy Equipment Operation';





--  2B: Find All-Star Projects

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