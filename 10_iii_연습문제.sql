-- 01
INSERT INTO depts
    (department_id, department_name, manager_id, location_id)
VALUES
    (280, '개발', null, 1800);
INSERT INTO depts (department_id, department_name, manager_id, location_id) VALUES (290, '회계부', null, 1800);
INSERT INTO depts (department_id, department_name, manager_id, location_id) VALUES (300, '재정', 301, 1800);
INSERT INTO depts (department_id, department_name, manager_id, location_id) VALUES (310, '인사', 302, 1800);
INSERT INTO depts (department_id, department_name, manager_id, location_id) VALUES (320, '영업', 303, 1700);

-- 02
-- (1)
UPDATE depts SET department_name = 'IT_bank'
WHERE department_name = 'IT_SUPPORT';

-- (2)
UPDATE depts SET department_id = 301
WHERE department_id = 290;

-- (3)
UPDATE depts SET 
    department_name = 'IT_Help', 
    department_id = 303, 
    location_id = 1800
WHERE department_name = 'IT_Helpdesk';

-- (4)
-- 이사 부장 과장 대리 : 290, 300, 310, 320
UPDATE depts
SET manager_id = 301
WHERE department_id IN (290, 300, 310, 320);

-- 03
-- (1)
DELETE FROM depts
WHERE department_id =
                    (SELECT department_id FROM depts
                    WHERE department_name = '영업');
-- 선생님답 ) 
DELETE FROM depts WHERE department_id = 320;                    
-- (2)
DELETE FROM depts WHERE department_id = 220;

-- 04
-- (1)
CREATE TABLE depts_사본 (SELECT * FROM depts);
DELETE FROM depts_사본 WHERE department_id > 200;

-- (2)
UPDATE depts_사본 SET manager_id = 100
WHERE manager_id IS NOT NULL;

-- (3),(4)
MERGE INTO depts a
    USING
        (SELECT * FROM departments) b
    ON 
    (a.department_id = b.department_id)
WHEN MATCHED THEN
    UPDATE SET
        a.department_name = b.department_name,
        a.manager_id = b.manager_id,
        a.location_id = b.location_id
WHEN NOT MATCHED THEN
    INSERT
        (b.department_id, b.department_name, b.manager_id, b.location_id);

-- 05
-- (1)
CREATE TABLE jobs_it_사본 (SELECT * FROM jobs
                        WHERE min_salary > 6000);

-- (2)
INSERT INTO jobs_it_사본
    (job_id, job_title, min_salary, max_salary)
VALUES
    ('IT_DEV', '아이티개발팀', 6000, 20000);
INSERT INTO jobs_it_사본 (job_id, job_title, min_salary, max_salary)
VALUES ('NET_DEV', '네트워크개발팀', 5000, 20000);
INSERT INTO jobs_it_사본 (job_id, job_title, min_salary, max_salary)
VALUES ('SEC_DEV', '보안개발팀', 6000, 19000);

-- (3), (4)
MERGE INTO jobs_it a
    USING 
        (SELECT * FROM jobs WHERE min_salary > 0) b
    ON
        (a.job_id = b.job_id)
WHEN MATCHED THEN
    UPDATE SET
        a.min_salary = b.min_salary
        a.max_salary = b.max_salary
WHEN NOT MATCHED THEN
    INSERT
        (b.job_id, b.job_title, b.min_salary, b.max_salary);
