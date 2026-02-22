
-- Module 1: Indexes

--  1A: Before Creating Index
EXPLAIN 
SELECT * 
FROM workers 
WHERE last_name = 'Johnson';

-- Create Simple Index
CREATE INDEX idx_worker_lastname 
ON workers(last_name);

-- 1A: After Creating Index
EXPLAIN 
SELECT * 
FROM workers 
WHERE last_name = 'Johnson';


-- 1B: Challenge - Composite Index

CREATE INDEX idx_projects_city_startdate
ON projects(site_city, start_date);