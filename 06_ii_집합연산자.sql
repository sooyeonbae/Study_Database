
-- 집합 연산자
-- UNION(합집합. 중복허용X), UNION ALL(합집합. 중복허용), INTERSECT(교집합), MINUS(차집합)
-- 위 아래 column개수가 정확히 일치해야 한다.

-- 1) UNION (겹치는 데이터를 알아서 한번만 출력)
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'  -- 세미콜론 지우기
UNION --합집합 연산.
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- 2) UNION ALL (겹치는 데이터를 여러번 출력)
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
UNION ALL
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- 3) INTERSECT (교집합)
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
INTERSECT
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;

-- 4) MINUS (A에서 교집합(A이자 B) 제외).
SELECT
    employee_id, first_name
FROM employees
WHERE hire_date LIKE '04%'
MINUS
SELECT
    employee_id, first_name
FROM employees
WHERE department_id = 20;




