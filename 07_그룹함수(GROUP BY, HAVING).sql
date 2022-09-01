
-- 그룹 함수 - AVG, MAX, MIN, SUM, **COUNT

SELECT
    AVG(salary),
    MAX(salary),
    MIN(salary),
    SUM(salary),
    COUNT(salary)
FROM employees; -- 테이블 전체가 그룹이다.

-- COUNT
SELECT COUNT(*) FROM employees; -- (*) : 전체 컬럼을 다 조회(null값 포함). 총 행 데이터의 수
SELECT COUNT(first_name) FROM employees; 
SELECT COUNT(commission_pct) FROM employees; -- (컬럼명) : null값 제외하고 카운트
SELECT COUNT(manager_id) FROM employees;

-- 부서별로 그룹화, 그룹함수의 사용
-- 주의할 점 1 : 그룹함수는 일반 컬럼과 동시에 그냥 출력할 수 없다.
SELECT
    department_id,
    AVG(salary),
FROM employees; -- error. 그룹함수(AVG(salary))는 그룹화를 한애들이랑 같이 구해야한다.
-- ->department_id로 그룹화를 하고나서 평균값 구하기.
SELECT
    department_id,
    AVG(salary),
FROM employees
GROUP BY department_id;
-- cf) 실행순서 : FROM - (JOIN) - (ON) - WHERE - GROUP BY - HAVING - SELECT - ORDER BY
                            -- ON : JOIN의 조건

-- 주의할 점 2 : GROUP BY절을 사용할 때 GROUP절에 묶이지 않으면 다른 컬럼을 조회할 수 없다.
SELECT
    job_id,
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id; --error. 그룹화하지않은 컬럼(job_id)는 같이 조회할 수 없다. ->join 하거나 그룹화 두개 설정
-- -> GROUP BY절을 2개 이상 사용
SELECT
    job_id,
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id, job_id
GROUP BY department_id;

-- 부서별 salary 합계
SELECT
    department_id,
    SUM(salary)
FROM employees
GROUP BY department_id;

-- 부서별 salary 합계 (100000이 넘는 부서만 조회)
SELECT
    department_id,
    SUM(salary)
FROM employees
WHERE SUM(salary) > 100000
GROUP BY department_id; -- error. WHERE에서 그룹화가 되지 않은 상태.
-- -> HAVING : 그룹화 한 이후에 HAVING으로 거르기 (GROUP BY에 조건 걸기)
SELECT
    department_id,
    SUM(salary)
FROM employees
GROUP BY department_id
HAVING SUM(salary) > 100000;

-- 직무별 직원이 몇명인지 (20명이 넘는 직무만 조회)
SELECT
    job_id,
    COUNT(*)
FROM employees
GROUP BY job_id
HAVING COUNT(*) >= 20;

-- 미니문제 : 부서 아이디가 50 이상인 것들을 그룹화시키고, 그룹 월급 평균 중 5000 이상만 조회.
SELECT
    department_id,
    AVG(salary) AS 평균
FROM employees
WHERE department_id >= 50 -- 그룹화 하기 전의 조건이라 WHERE
GROUP BY department_id
HAVING AVG(salary) >= 5000 -- 그룹화 이후의 조건이라 HAVING. SELECT 전이라 '평균' 쓰면 안된다.
ORDER BY department_id DESC;