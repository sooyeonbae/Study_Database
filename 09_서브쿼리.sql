
/*
# 서브쿼리

- 서브쿼리의 사용방법은 ( ) 안에 명시함.
서브쿼리절의 리턴행이 1줄 이하여야 합니다.
- 서브쿼리 절에는 비교할 대항이 하나 반드시 들어가야 합니다.
- 해석할 때는 서브쿼리절부터 먼저 해석하면 됩니다.
(서브쿼리 안에서 ORDER BY 사용불가)
*/

-- 'Nancy'의 급여보다 급여가 많은 사람을 검색하는 문장. (참고:낸시의 샐러리: 12008)
SELECT * FROM employees
WHERE salary > (SELECT salary 
                FROM employees 
                WHERE first_name = 'Nancy');

-- employee_id가 103번인 사람과 job_id가 동일한 사람을 검색하는 문장.
-- 괄호안에들어갈내용 먼저 써보기)
SELECT job_id FROM employees WHERE employee_id = 103;
--
SELECT * FROM employees
WHERE job_id = (SELECT job_id 
                FROM employees 
                WHERE employee_id = 103);


-- <서브쿼리의 종류>
-- 1) 단일행 서브쿼리 : 하나의 행을 리턴 (=, <, =< , ... <>(같지않음))
-- 2) 다중행 서브쿼리 : 여러개의 행을 리턴

SELECT * FROM employees
WHERE job_id = (SELECT job_id
                FROM employees
                WHERE job_id = 'IT_PROG'); -- error. 단일행 연산자를 사용하면서 서브쿼리 리턴행이 여러개라서.
                                            -- -> 다중행 연산자를 사용해야한다.
-- 다중행 연산자
-- **(1) IN : 목록의 어떤 값과 같은지 확인합니다.
SELECT * FROM employees
WHERE job_id IN (SELECT job_id
                FROM employees
                WHERE job_id = 'IT_PROG');

-- (2) ANY : 값을 서브쿼리에 의해 리턴된 각각의 값과 비교합니다. (SOME도 거의같게쓰인다.)
-- 하나라도 만족하면 됩니다. 

-- first_name이 David인 사람 중 가장 작은 값보다 급여가 큰 사람 조회하기
SELECT salary FROM employees WHERE first_name = 'David'; -- 가장 적게받는 David : 4800

SELECT * FROM employees
WHERE salary > ANY (SELECT salary 
                    FROM employees 
                    WHERE first_name = 'David');    -- 부등호를 하나라도 만족하면 된다.
                                                    -- ANY David의 급여보다 많은사람 : 4800받는 David보다 다 많음

-- (3) ALL : 값을 서브쿼리에 의해 리턴된 값과 모두 비교해서
-- 모두 만족해야 합니다.

SELECT * FROM employees
WHERE salary > ALL (SELECT salary 
                    FROM employees 
                    WHERE first_name = 'David');    -- 모든 부등호를 만족시켜야한다.   
                                                    -- 가장 많이버는 David (9300)보다 많이 버는 사람들 출력

-- 3) 스칼라 서브쿼리
-- 서브쿼리가 SELECT 구문에 온다. LEFT OUTER JOIN과 유사한 결과가 나온다.
SELECT
    e.first_name, d.department_name
FROM employees e 
LEFT JOIN departments d 
ON e.department_id = d.department_id
ORDER BY first_name ASC;

-- JOIN을 쓰지 않고 서브쿼리로 붙여서 가져오기 (결과 동일) (보통 조인 많이씀. 조회되는 결과값이 딱 떨어질때는 스칼라서브쿼리 쓰기가 좋다.)
SELECT
    e.first_name,
    (
        SELECT department_name
        FROM departments d
        WHERE d.department_id = e.department_id
    ) AS department_name        -- SELECT에서 서브쿼리
FROM employees e 
ORDER BY first_name ASC;
/* - 스칼라 서브쿼리가 조인보다 좋은 경우
 : 함수처럼 한 레코드당 정확히 하나의 값만을 리턴할 떄. 
 
    - 조인이 스칼라 서브쿼리보다 좋은 경우
 : 조회할 데이터가 대용량인 경우, 해당 데이터가 수정 삭제등이 빈번한 경우. */

-- 각 부서의 매니저의 이름 뽑기
-- LEFT OUTER JOIN ver.
SELECT 
    d.*, e.first_name
FROM departments d 
LEFT JOIN employees e 
ON d.manager_id = e.employee_id
ORDER BY d.manager_id ASC;

-- 스칼라 서브쿼리 ver.
SELECT
    d.*,
    (
        SELECT first_name
        FROM employees e
        WHERE e.employee_id = d.manager_id
    ) AS manager_name
FROM departments d
ORDER BY d.manager_id ASC;

-- 각 부서별 사원수 뽑기 (departments의 모든 컬럼, 사원 수를 별칭을 지어서 출력)
SELECT
    d.*,
    (
        SELECT COUNT(*)
        FROM employees e 
        WHERE e.department_id = d.department_id -- 순서주의
        GROUP BY department_id
    ) AS department_count
FROM departments d;

-- 4) 인라인뷰 : FROM 구문에 서브쿼리가 오는 것
-- 순번을 정해놓은 조회 자료를 범위를 지정해서 가지고 오는 경우.

-- salary로 정렬을 진행하면서 ROWNUM을 붙이면 ROWNUM이 정렬이 되지 않는 사태가 발생합니다.
-- 이유 : ROWNUM이 먼저 붙고 정렬이 진행되기 떄문. ORDER BY는 항상 마지막에 진행.
-- 해결 : 정렬이 미리 진행된 자료에 ROWNUM을 붙여서 다시 조회하는 것이 좋을 것 같아요.
SELECT ROWNUM AS rn, employee_id, first_name, salary
FROM employees
ORDER BY salary DESC; -- rn이 select될때 발동해서 order by 하고나서 보면 rn 뒤죽박죽이다.
                    -- -> order by 하고서 rn 붙이자 . (이 떄 서브쿼리이용)

-- ->
SELECT ROWNUM AS rn, tbl.* FROM
    (
        SELECT employee_id, first_name, salary
        FROM employees
        ORDER BY salary DESC
    ) tbl; -- 별칭 (AS 생략가능)

-- ROWNUM을 붙이고 나서 범위를 지정해서 조회하려고 하는데, 범위 지정도 불가능하고 지목할 수 없는 문제가 발생하더라.
-- 이유 : WHERE절부터 먼저 실행하고 나서 ROWNUM이 SELECT되기때문에
-- 해결 : ROWNUM까지 붙여놓고 다시 한 번 자료를 SELECT해서 범위를 지정해야 되겠구나.

-- 가장 안쪽 SELECT 절에서 필요한 테이블형식(인라인뷰)을 생성.
-- 바깥쪽 SELECT 절에서 ROWNUM을 붙여서 다시 조회
-- 가장 바깥쪽 SELECT 절에서는 이미 붙어있는 RONUM의 범위를 지정해서 조회.
-- SQL의 실행 순서 : FROM - WHERE - GROUP BY - HAVING - SELECT - ORDER BY

-- -> ROWNUM으로 범위 정하기 위해서는 한 번 더 감싸야한다. (WHERE쓰면 ROWNUM보다 먼저 해석돼서 오류난다.)
SELECT * FROM
    (
    SELECT ROWNUM AS rn, tbl.* FROM
        (
            SELECT employee_id, first_name, salary
            FROM employees
            ORDER BY salary DESC
        ) tbl
    )
WHERE rn<=20 AND rn>10;     -- paging 할때 활용하기. (중간부분 삭제돼도 개수보장해서 조회 가능)



--
SELECT * FROM
    (
    SELECT TO_CHAR(TO_DATE(test, 'YY/MM/DD'), 'MMDD') AS mm
            , name FROM
        (
        SELECT '홍길동' AS name, '20211126' AS test FROM dual UNION ALL
        SELECT '김철수', '20210301' FROM dual UNION ALL
        SELECT '박영희', '20210401' FROM dual UNION ALL
        SELECT '김뽀삐', '20210501' FROM dual UNION ALL
        SELECT '박뚜띠', '20210601' FROM dual UNION ALL
        SELECT '김테스트', '20210701' FROM dual
        )
    )
WHERE mm = '1126';