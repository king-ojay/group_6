# Big3 Construction - Phase 2 Advanced SQL Implementation

## Project Overview
Big3 Construction has transitioned from basic data storage to a refined system focused on performance, security and automation. Following the successful normalization of their database to 5NF, this Phase 2 project implements advanced features to optimize data retrieval, simplify access for varied roles and automate business processes.

## Learning Objectives
- **Performance Optimization**: Creating targeted Indexes.
- **Complex Analytics**: Using Subqueries and advanced JOINs.
- **Security & Simplicity**: Implementing database Views.
- **Business Automation**: Developing Stored Procedures.
- **Data Integrity**: Enforcing rules via Triggers.
- **Maintenance**: Scheduling recurring database Events.

---

## Module Challenge Justifications

### Module 1: Indexes (The "Need for Speed")
**Challenge:** Creating a Composite Index for project filtering and sorting.
- **Index:** `idx_projects_city_startdate ON projects(site_city, start_date)`
- **Justification:** `site_city` was placed first as it is the primary filter in the WHERE clause (high selectivity). `start_date` was placed second to allow MySQL to perform the ORDER BY sorting directly from the index, avoiding an expensive `filesort` operation.

### Module 2: Subqueries & Advanced Joins (The "Complex Questions")
**Challenge:** Finding "All-Star Projects" (highest worker count).
- **Justification:** The solution uses a "max of a count" pattern. An inner subquery calculates the count of workers per project, and an outer subquery finds the maximum value of those counts. The `HAVING` clause then filters the results to only show projects matching that maximum, correctly handling ties.

### Module 3: Views (The "Simple & Secure" Reports)
**Challenge:** Financial Summary View (`v_project_financial_summary`).
- **Justification:** This view aggregates data from `projects`, `clients`, and `project_materials`. It uses `LEFT JOIN` on materials to ensure projects with zero materials are still included, and `COALESCE` to handle NULL sums, accurately calculating the `remaining_budget`.

### Module 4: Stored Procedures (The "One-Click" Tasks)
**Challenge:** "Smart" Worker Assignment (`sp_assign_worker_to_project`).
- **Justification:** The procedure uses an `OUT` parameter to provide meaningful feedback to the caller. It implements conditional logic to check for existing assignments before inserting, preventing primary key violations and ensuring a "success" or "error" message is returned.

### Module 5: Triggers (The "Automatic Rule-Enforcer")
**Challenge:** Safety Certification Validation.
- **Justification:** A `BEFORE INSERT` trigger on `project_assignments` proactively validates worker eligibility. It queries the `certifications` table for a 'Basic Safety' cert; if the cert is missing or expired, it uses `SIGNAL SQLSTATE '45000'` to block the transaction, ensuring that safety rules are never bypassed.

### Module 6: Events (The "Scheduled Maintenance")
**Challenge:** Monthly Project Archival.
- **Justification:** The event `ev_archive_old_projects` is scheduled to run monthly. It utilizes an ACID-compliant transaction to first copy projects older than 5 years into the `archived_projects` table and then delete them from the main `projects` table, maintaining data cleanliness without manual intervention.

---

## Team Contribution Statement


- **[Member Name 1]**: [Contributed to Modules X, Y, Z]
- **[Member Name 2]**: [Contributed to Modules A, B, C]
- **[Member Name 3]**: [Contributed to Modules D, E, F]
- **[Member Name 4]**: [Contributed to Modules D, E, F]

---

## Documentation of Individual Contributions
The official PDF documentation of individual contributions can be found here:
[Individual_Contributions.pdf](./Individual_Contributions.pdf)

---

## Technical Setup
- **Database**: MySQL
- **Tooling**: DataGrip / MySQL Workbench
- **ERD Visualization**: Markdown Preview Mermaid Support (VS Code extension)
