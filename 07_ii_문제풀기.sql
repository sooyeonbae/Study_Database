-- 01. 사원 테이블에서 JOB_ID별 사원 수를 구하세요. 사원테이블에서 JOB_ID별 월급의 평균을 구하세요. 월급의 평균 순으로 내림차순 정렬하세요.
SELECT
    job_id,
    COUNT(job_id) AS 사원수,
    AVG(salary) AS 평균월급
FROM employees
GROUP BY job_id
ORDER BY AVG(salary) DESC;

-- 02. 사원테이블에서 입사 년도 별 사원 수를 구하세요.
SELECT
    SUBSTR(hire_date, 1, 2) AS 입사년도,
    COUNT(SUBSTR(hire_date, 1, 2)) AS 사원수
FROM employees
GROUP BY SUBSTR(hire_date, 1, 2);

-- MySQL (YYYY-MM-DD)버전
SELECT
    SUBSTR(hire_date, 3, 2) AS 입사년도,
    COUNT(SUBSTR(hire_date, 3, 2)) AS 사원수
FROM employees
GROUP BY SUBSTR(hire_date, 3, 2);

-- 03. 급여가 1000 이상인 사원들의 부서별 평균 급여를 출력하세요. 단 부서 평균 급여가 2000 이상인 부서만 출력
SELECT
    department_id AS 부서,
    AVG(salary) AS 평균급여
FROM employees
WHERE salary >= 1000
GROUP BY department_id
HAVING AVG(salary) >= 2000;

-- 04. 사원 테이블에서 commission_pct(커미션) 컬럼이 null이 아닌 사람들의 department_id(부서별) salary(월급)의 평균, 합계, count를 구합니다.
-- 조건 1) 월급의 평균은 커미션을 적용시킨 월급입니다. 
-- 조건 2) 평균은 소수 2째 자리에서 절삭 하세요.
SELECT
    department_id AS 부서,
    TRUNC(AVG(salary + (salary*commission_pct)), 2) AS 부서별월급평균,
    SUM(salary) AS 부서별월급합계,
    COUNT(department_id) AS 성과금수령자
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id;