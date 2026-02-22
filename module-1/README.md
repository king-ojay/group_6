**Module 1: Indexes (The "Need for Speed")
**Client Request

The project managers reported that searching for workers by last name and filtering projects by city was slow. The goal was to optimize these frequent queries to improve application performance.

**Part 1A – Simple Index on workers(last_name)
**
**Analysis (Before Index)
**
To evaluate performance, the following query was analyzed:

EXPLAIN SELECT * FROM workers WHERE last_name = 'Johnson';

Before creating the index:

type: ALL

key: NULL

rows: large number (full table scan)

This indicates that MySQL was scanning the entire workers table to find matching records.

**Implementation**

To optimize this, the following index was created:

CREATE INDEX idx_worker_lastname ON workers(last_name);

Verification (After Index)

After creating the index, the EXPLAIN query was run again:

EXPLAIN SELECT * FROM workers WHERE last_name = 'Johnson';

Now:

type: ref

key: idx_worker_lastname

rows: significantly decreased

This confirms that MySQL is now using the index instead of performing a full table scan.

**Part 1B – Challenge: Composite Index on projects
**
**Business Requirement
**
The client frequently runs queries that:

Filter projects by site_city

Sort results by start_date

**Typical query:
**
SELECT * FROM projects WHERE site_city = 'Kigali' ORDER BY start_date;

**Solution Implemented
**
CREATE INDEX idx_projects_city_startdate ON projects(site_city, start_date);

Justification for Column Order

site_city was placed first because it is used in the WHERE clause for filtering.

start_date was placed second because the results are sorted using ORDER BY start_date.

MySQL uses composite indexes from left to right.

By placing site_city first, the database can efficiently narrow down the rows.
Since start_date is the second column, MySQL can also use the same index to sort without performing an additional filesort operation.

This improves both filtering and sorting performance.

**Performance Verification
**
The following query was tested:

EXPLAIN SELECT * FROM projects WHERE site_city = 'Kigali' ORDER BY start_date;

**Execution plan confirmed:
**
The index idx_projects_city_startdate was used

No full table scan occurred

Sorting was optimized without using filesort

**Challenges Faced
**
Environment Setup Issue: Initially, the database was not available locally because it had been created on a teammate’s machine. This required requesting the original schema setup file and configuring MySQL locally.

Understanding EXPLAIN Output: Interpreting the meaning of type, rows, and key required careful analysis to confirm performance improvements.

Composite Index Column Order: Determining the correct order of columns in the composite index required understanding MySQL’s left-to-right index rule.
