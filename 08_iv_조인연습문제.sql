-- 01
-- 01.01 inner join
SELECT
    e.department_id
FROM employees e, departments d
WHERE e.department_id INNER JOIN d.department_id;

-- 07
SELECT
    e.employee_id, e.first_name, e.last_name, e.salary, d.department_name, loc.city
FROM employees e 
JOIN departments d
ON e.department_id = d.department_id
JOIN locations loc
ON d.location_id = loc.location_id
WHERE e.job_id = 'SA_MAN';

-- 08
SELECT
    e.employee_id, e.first_name, j.job_title
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
WHERE job_title IN ('Stock Manager', 'Stock Clerk');
-- OR도 되지마 여기서 선생님은 IN 써봄


-- 09
SELECT
    d.department_name
FROM departments d
LEFT OUTER JOIN employees e     --순서주의
ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;

-- 10
SELECT
    e1.first_name, e2.first_name AS managername
FROM employees e1
JOIN employees e2
ON e1.Managerid = e2.employee_id;


-- 11.
SELECT
    e1.first_name, e2.employee_id, e2.first_name, e2.salary
FROM employees e1
JOIN employees e2
ON e1.employee_id = e2. manager_id
ORDER BY e2.salary DESC;
--선생님꺼 IS NOT NULL씀 다시확인해라.