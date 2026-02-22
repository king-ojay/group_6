-- Module 4: Stored Procedures - Big3 Construction
-- Automates repetitive tasks for HR and project management

-- Part 4A: Guided Activity - Add Worker with Skill
-- Simplifies adding a new worker and assigning their primary skill
DELIMITER $$

CREATE PROCEDURE sp_add_worker_with_skill(
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_salary DECIMAL(10, 2),
    IN p_skill_name VARCHAR(100)
)
BEGIN
    DECLARE v_worker_id INT;
    DECLARE v_skill_id INT;

    START TRANSACTION;

    -- Insert the new worker
    INSERT INTO workers(first_name, last_name, phone, salary)
    VALUES (p_first_name, p_last_name, p_phone, p_salary);

    SET v_worker_id = LAST_INSERT_ID();

    -- Look up the skill ID
    SELECT skill_id INTO v_skill_id FROM skills WHERE skill_name = p_skill_name;

    -- Link worker to skill if it exists
    IF v_skill_id IS NOT NULL THEN
        INSERT INTO worker_skills(worker_id, skill_id)
        VALUES (v_worker_id, v_skill_id);
    END IF;

    COMMIT;
END$$

DELIMITER ;

-- Test the procedure
CALL sp_add_worker_with_skill('Alice', 'Smith', '555-1234', 75000.00, 'Project Management');

-- Part 4B: Challenge Task - Assign Worker to Project
-- Prevents duplicate assignments and provides feedback
DELIMITER $$

CREATE PROCEDURE sp_assign_worker_to_project(
    IN p_worker_id INT,
    IN p_project_id VARCHAR(10),
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Check if assignment already exists
    SELECT COUNT(*) INTO v_count
    FROM project_assignments
    WHERE worker_id = p_worker_id AND project_id = p_project_id;

    IF v_count > 0 THEN
        SET p_message = 'Error: Worker already assigned to this project.';
    ELSE
        INSERT INTO project_assignments(worker_id, project_id, assignment_date)
        VALUES (p_worker_id, p_project_id, CURDATE());
        SET p_message = 'Success: Worker assigned.';
    END IF;
END$$

DELIMITER ;

-- Test the procedure with a new assignment
CALL sp_assign_worker_to_project(1, 'P001', @message);
SELECT @message;

-- Test with duplicate assignment (should return error message)
CALL sp_assign_worker_to_project(1, 'P001', @message);
SELECT @message;
