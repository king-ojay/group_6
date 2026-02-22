USE big3_construction;

-- Module 6: Events
-- Part 6A: Enable Event Scheduler

SHOW VARIABLES LIKE 'event_scheduler';
SET GLOBAL event_scheduler = ON;

-- Part 6B: Archive Old Projects

CREATE TABLE archived_projects (
    project_id VARCHAR(10) PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    site_address VARCHAR(200),
    site_city VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12, 2),
    client_id INT,
    archived_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE EVENT ev_archive_old_projects
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP + INTERVAL 1 MONTH
DO
BEGIN
    START TRANSACTION;
    
    INSERT INTO archived_projects (project_id, project_name, site_address, site_city, start_date, end_date, budget, client_id)
    SELECT project_id, project_name, site_address, site_city, start_date, end_date, budget, client_id
    FROM projects
    WHERE end_date IS NOT NULL AND end_date < CURDATE() - INTERVAL 5 YEAR;
    
    DELETE FROM projects
    WHERE end_date IS NOT NULL AND end_date < CURDATE() - INTERVAL 5 YEAR;
    
    COMMIT;
END$$

DELIMITER ;
