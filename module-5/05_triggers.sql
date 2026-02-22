USE big3_construction;

-- Module 5: Triggers
-- Part 5A: Budget Audit Trigger

CREATE TABLE project_budget_audit (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id VARCHAR(10),
    old_budget DECIMAL(12, 2),
    new_budget DECIMAL(12, 2),
    change_user VARCHAR(100),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER trg_audit_project_budget_update
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
    IF NEW.budget > OLD.budget THEN
        INSERT INTO project_budget_audit(project_id, old_budget, new_budget, change_user)
        VALUES (OLD.project_id, OLD.budget, NEW.budget, USER());
    END IF;
END$$

DELIMITER ;

-- Test the trigger
UPDATE projects SET budget = budget + 50000 WHERE project_id = 'P001';
SELECT * FROM project_budget_audit;

-- Part 5B: Safety Certification Validation Trigger

DELIMITER $$

CREATE TRIGGER trg_validate_safety_cert_before_assignment
BEFORE INSERT ON project_assignments
FOR EACH ROW
BEGIN
    DECLARE v_expiry_date DATE;
    
    SELECT expiry_date INTO v_expiry_date
    FROM certifications
    WHERE worker_id = NEW.worker_id AND cert_name = 'Basic Safety'
    LIMIT 1;
    
    IF v_expiry_date IS NULL OR v_expiry_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Worker safety certification is expired or missing.';
    END IF;
END$$

DELIMITER ;
