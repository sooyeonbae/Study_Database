-- MERGE : 테이블 병합

/*
INSERT와 UPDATE를 한방에 처리
한 테이블에 해당하는 테이터가 있다면 UPDATE를,
없으면 INSERT로 처리해라.
만약 MERGE가 없었다면 해당 데이터의 존재 유무를 일일히 확인하고
if문을 사용해서 데이터가 있다면 UPDATE, 없다면 else문을 사용해서
INSERT를 하라고 일일히 얘기해야 하는데, MERGE를 통해 쉽게 처리 가능.
*/

CREATE TABLE emps_it AS (SELECT * FROM employees WHERE 1=2); --구조만 따오기

INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES (105, 'David', 'Kim', 'DAVKIM', '22/04/27', 'IT_PROG');

SELECT * FROM employees
WHERE job_id = 'IT_PROG';

MERGE INTO emps_it AS a     -- (  AS 생략가능), 머지를 할 타겟테이블 정해주기
    USING -- 병합시킬 데이터 작성
        (SELECT * FROM employees WHERE job_id = 'IT_PROG') b    -- 조인 구문. 별칭은 b
    ON -- 병합시킬 데이터의 연결 조건
        (a.employee_id = b.employee_id) -- 조인조건 : ( a와 b emp_id같다면(이미 있다면, 105번의 경우) )
-- a에도 이미 105번이 있고 b에도 105번이 있어서 얘는 INSERT가 아니라 UPDATE를 해야한다.
WHEN MATCHED THEN -- 조건에 일치할 경우 타겟 테이블에 이렇게 실행해라.
    UPDATE SET
        a.phone_number = b.phone_number,
        a.hire_date = b.hire_date,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
WHEN NOT MATCHED THEN -- 조건에 일치하지 않는 경우 타겟 테이블에 이렇게 실행해라.
    INSERT /*컬럼명 지정할 경우 컬럼자리*/ VALUES
        (b.employee_id, b.first_name, b.last_name,
        b.email, b.phone_number, b.hire_date, b.job_id,
        b.salary, b.commission_pct, b.manager_id, b.department_id);


-- ----------------
-- 머지연습2
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES(102, '렉스', '박', 'LEXPARK', '01/04/06', 'AD_VP');
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES(101, '니나', '최', 'NINA', '20/04/06', 'AD_VP');
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES(103, '흥민', '손', 'HMSON', '20/04/06', 'AD_VP');

-- 전제조건걸기 - employees 테이블을 매번 수정되는 테이블이라고 가정하자.
-- 기존의 데이터는 email, phone, salary, comm_pct, man_id, dept_id는 업데이트 하도록 처리
-- 새로 유입된 데이터는 그대로 추가.

MERGE INTO emp_it a
    USING
        (SELECT * FROM employees) b
    ON
        (a.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET
        a.email = b.email,
        a.phone_number = b.phone_number,
        a.salary = b.salary, 
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
WHEN NOT MATCHED THEN
    INSERT
        (b.employee_id, b.first_name, b.last_name,
        b.email, b.phone_number, b.hire_date, b.job_id,
        b.salary, b.commission_pct, b.manager_id, b.department_id);

-- merge에서 delete도 가능하다.
ROLLBACK;
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES (105, 'David', 'Kim', 'DAVKIM', '22/04/27', 'IT_PROG');
/*DELETE만 단독으로 쓸 수는 없고
UPDATE 이후에 DELETE 작성이 가능합니다.
(UPDATE 된 대상을 DELETE 하도록 설계되어있기때문에...

삭제할 대상 컬럼들을 동일한 값으로 일단 UPDATE를 진행하고
DELETE의 WHERE절에 아까 지정한 동일한 값을 지정해서 삭제합니다.*/

-- 기존에 존재한다면 삭제하고, 나머지는 INSERT하기

MERGE INTO emps_it a -- (머지를 할 타겟 테이블)
    USING -- 병합시킬 데이터
        (SELECT * FROM employees WHERE job_id = 'IT_PROG') b -- 조인 구문
    ON -- 병합시킬 데이터의 연결 조건
        (a.employee_id = b.employee_id) -- 조인 조건
WHEN MATCHED THEN -- 조건에 일치할 경우 타겟 테이블에 이렇게 실행해라.
    UPDATE SET
        a.phone_number = b.phone_number,
        a.hire_date = b.hire_date,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id

    DELETE              -- update할때 만만한 컬럼을 만만한 값으로 변경한다음에 걔네들을 다 삭제하는 방식으로도 쓴다.
    WHERE a.employee_id = b.employee_id
    
WHEN NOT MATCHED THEN -- 조건에 일치하지 않는 경우 타겟 테이블에 실행.
    INSERT /*속성(컬럼)*/ VALUES
        (b.employee_id, b.first_name, b.last_name,
         b.email, b.phone_number, b.hire_date, b.job_id,
         b.salary, b.commission_pct, b.manager_id, b.department_id);

    