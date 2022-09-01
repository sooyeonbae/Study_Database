-- 01
-- (1)
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) from employees);

-- (2)
SELECT COUNT(*) FROM employees
WHERE salary > (SELECT AVG(salary) from employees);

-- (3)
SELECT * FROM employees
WHERE salary > (
                SELECT AVG(salary)
                FROM employees
                WHERE job_id = 'IT_PROG'
);

-- 02
SELECT * FROM employees e
WHERE department_id = (SELECT department_id
                        FROM departments
                        WHERE manager_id = 100);

-- 03
-- (1)
SELECT * FROM employees
WHERE manager_id > (SELECT manager_id FROM employees WHERE first_name = 'Pat');
-- (2)
SELECT * FROM employees
WHERE manager_id IN
(SELECT manager_id FROM employees
WHERE first_name = 'James');

-- 04 

--05

-- 06
SELECT
    e.employee_id, e.first_name, e.last_name, e.department_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id
ORDER BY e.employee_id ASC;

-- 07
SELECT
    e.employee_id, e.first_name, e.last_name, e.department_id, 
    (SELECT department_name FROM departments
    WHERE department_id = e.department_id) AS department_name
FROM employees e
ORDER BY e.employee_id ASC;

-- 08
SELECT
    d.department_id, d.department_name, d.manager_id,
    d.location_id, loc.street_address, loc.postal_code, loc.city
FROM departments d LEFT OUTER JOIN locations loc 
ON d.location_id = loc.location_id
ORDER BY d.department_id ASC;

-- 09 (하나하나씩 다 해줘야하는거였군... 조인이 더 많이쓰이는 이유.)
SELECT
    department_id, department_name, manager_id, d.location_id,
    (SELECT loc.street_address
    FROM locations loc
    WHERE loc.location_id = d.location_id) AS street_address,
    (SELECT loc.postal_code
    FROM locations loc
    WHERE loc.location_id = d.location_id) AS postal_code,
    (SELECT loc.city
    FROM locations loc
    WHERE loc.location_id = d.location_id) AS city
FROM departments d
ORDER BY d.department_id ASC;

-- 10
SELECT
    loc.location_id, loc.street_address, loc.city,
    loc.country_id, c.country_name
FROM locations loc LEFT OUTER JOIN countries c
ON loc.country_id = c.country_id
ORDER BY c.country_name ASC;

-- 11 (다시보기)
SELECT location_id, street_address, city, country_id,
    (SELECT country_name
    FROM countries
    WHERE loc.country_id = country_id) country
FROM locations loc
ORDER BY country ASC;

-- 12
SELECT * FROM
(SELECT ROWNUM AS rn, emp.* FROM(
    SELECT  e.employee_id,
            e.first_name|| ' ' ||e.last_name AS name,
            e.phone_number,
            e.hire_date,
            e.department_id,
            d.department_name
    FROM employees e LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id
    ORDER BY hire_date ASC) AS emp
)
WHERE rn <=10;

-- 13
SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d 
ON e.department_id = d.department_id
WHERE e.job_id = 'SA_MAN';

-- 14
SELECT  department_id, 
        department_name, 
        manager_id, 
        (SELECT COUNT (*) FROM employees
        GROUP BY department_id)
FROM departments
GROUP BY department_id;

-- 15
SELECT * FROM departments;

--14번 다시해보자 나야...

-- 16 : 15번 묶어서 별칭붙이고 괄호묶고 밖에서ㅓSELECT ROWNUM AS rn, tbl.* FROM하고 이거를 또 묶어서
    -- SELECT * FROM 하고 괄호닫은다음에 WHERE rn >10 AND rn <=20;