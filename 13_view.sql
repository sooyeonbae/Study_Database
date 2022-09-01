-- 뷰 : 가상의 테이블
                                                -- cf. 인라인뷰 : FROM절에 붙이는 서브쿼리
-- 함수 들어오면 안된다.


/*
view는 제한적인 자료만 보기 위해 사용하는 가상테이블의 개념입니다.
뷰는 기본 테이블로 유도된 가상 테이블이기 때문에
필요한 컬럼만 저장해 두면 관리가 용이해집니다.
뷰는 가상테이블로 실제 데이터가 물리적으로 저장된 형태는 아닙니다.
뷰를 통해서 데이터에 접근하면 원본 데이터는 원본 데이터는 안전하게 보호될 수 있습니다.
*/                                                

-- 권한 확인 sql
SELECT * FROM user_sys_privs;
            -- CREATE VIEW 권환 있는지 확인

-- 단순 뷰
SELECT
    employee_id,
    first_name || ' ' || last_name AS name,
    job_id,
    salary
FROM employees
WHERE department_id = 60;            

CREATE VIEW view_emp AS (    --view_emp : view 이름
    SELECT
        employee_id,
        first_name || ' ' || last_name AS name,
        job_id,
        salary
    FROM employees
    WHERE department_id = 60
);

-- 복합 뷰 : 여러 테이블을 조인하여 필요한 데이터만 저장하고 빠른 확인을 위해 사용.
CREATE VIEW view_emp_dept_jobs AS (
    SELECT
        e.employee_id,
        e.first_name || ' ' || e.last_name AS name,
        d.department_name,
        j.job_title
    FROM employees e
    LEFT JOIN departments d 
    ON e.department_id = d.department_id
    LEFT JOIN jobs j 
    ON e.job_id = j.job_id
)
ORDER BY employee_id ASC;

SELECT * FROM view_emp_dept_jobs;


-- 뷰의 수정 (CREATE OR REPLACE VIEW 구문)
-- 동일 이름으로 해당 구문을 사용하면 데이터가 변경되면서 새롭게 생성됩니다.

CREATE OR REPLACE VIEW view_emp_dept_jobs AS (
    SELECT
        e.employee_id,
        e.first_name || ' ' || e.last_name AS name,
        d.department_name,
        j.job_title,
        e.salary -- 추가한내용
    FROM employees e
    LEFT JOIN departments d 
    ON e.department_id = d.department_id
    LEFT JOIN jobs j 
    ON e.job_id = j.job_id
)
ORDER BY employee_id ASC;

SELECT * FROM view_emp_dept_jobs;



-- 활용예시
SELECT
    job_title, AVG(salary)
FROM view_emp_dept_jobs
GROUP BY job_title
ORDER BY AVG(salary) DESC;


-- - - - - - - - - - - - - - - - - -  -
-- 뷰 삭제
DROP VIEW view_emp;


/*VIEW에 INSERT가 일어나는 경우 원본테이블에도 반영이 됩니다.
그래서 VIEW의 INSERT, UPDATE, DELETE에는 많은 제약사항이 따릅니다.
원본테이블이 NOT NULL인 경우 VIEW에 INSERT가 불가능합니다.
VIEW에서 사용하는 컬럼이 가상열인경우(ex.name)에도 안됩니다.
*/

-- VIEW에  INSERT하기
INSERT INTO view_emp_dept_jobs
VALUES (300, 'test', 'test', 'test', 10000); -- error. 가상열(virtual column)이 있어서 (name).

INSERT INTO view_emp_dept_jobs
(employee_id, department_name, job_title, salary)
VALUES (300, 'test', 'test', 'test');   --error. 여러 테이블이 JOIN된 뷰의 경우 한번에 수정할 수 없습니다.

CREATE VIEW view_emp AS (       -- 단순뷰 만들어놓고
        employee_id,
        first_name || ' ' || last_name AS name,
        job_id,
        salary
    FROM employees
    WHERE department_id = 60
);

INSERT INTO view_emp
(employee_id, job_id, salary)
VALUES (300,'test',10000);  -- error. last_name이 not null이라서 employees에 넣을 수 없다.
                            -- 원본테이블의 null을 허용하지 않는 컬럼 때문에 들어갈 수 없습니다.


-- WITH CHECK OPTION -> 조건 제약 컬럼 (UPDATE를 막아줌)
-- 조건에 사용되어진 컬럼값은 뷰를 통해서 변경할 수 없게 해주는 키워드.
CREATE VIEW view_emp_test AS (
    SELECT
        employee_id,
        first_name,
        last_name,
        hire_date,
        job_id,
        department_id
    FROM employees
    WHERE department_id = 60
)
WITH CHECK OPTION CONSTRAINT view_emp_test_ck; -- 자체적으로 제약걸기 (변경 못하게)

UPDATE view_emp_test
SET department_id = 100
WHERE employee_id = 105;    -- error. 제약걸려있기때문에


-- WITH READONLY -> DML연산을 막아준다. SELECT만 허용. 읽기 전용 뷰
CREATE OR REPLACE VIEW view_emp_test AS (
    SELECT
        employee_id,
        first_name,
        last_name,
        hire_date,
        job_id,
        department_id
    FROM employees
    WHERE department_id = 60
)
WITH READONLY;

INSERT INTO view_emp_test
VALUES (300, 'test', 'test', sysdate, 'IT_PROG', 100); -- error. READONLY라 DML연산 진행 불가능.

UPDATE view_emp_test
SET last_name = 'kim'
WHERE employee_id = 103; -- error. READONLY라니깐