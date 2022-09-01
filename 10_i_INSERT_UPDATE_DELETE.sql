
-- INSERT
-- 테이블 구조 확인하기 : discribe 'DESC'
DESC departments;

-- INSERT 방법 1. (모든 컬럼 데이터를 한번에 저장)
INSERT INTO departments
VALUES (280, '개발자', null, 1700);     --컬럼을 따로 지정하지않고

ROLLBACK; --실행시점을 다시 뒤로 되돌리는 키워드

-- INSERT 방법 2. (직접 컬럼을 지정하고 저장)
INSERT INTO departments
    (department_id, department_name, location_id)
VALUES
    (280, '개발자', 1700);

-- INSERT 연습
INSERT INTO departments VALUES (290, '디자이너', null, 1700);
INSERT INTO departments VALUES (300, 'DB관리자', null, 1800);
INSERT INTO departments VALUES (310, '데이터분석가', null, 1800);
INSERT INTO departments VALUES (320, '퍼블리셔', 200, 1800);
INSERT INTO departments VALUES (330, '서버관리자', 200, 1800);

ROLLBACK;

-- --------------------
-- 사본테이블 생성하기 : CTAS
CREATE TABLE managers AS    -- managers:사본테이블이름 
(SELECT employee_id, first_name, job_id, hire_date
FROM employees WHERE 1=2);            -- 선택한 컬럼들로 managers라는 테이블 만들기.
                                    -- WHERE절에 1=2같은 FALSE값 주면 안에있는 구조만 가져옴 (데이터 X)
                                    --          1=1     TRUE            데이터까지 다 가져옴
                                    -- WHERE안주면 TRUE로 데이터까지 복사됨

DROP TABLE managers; -- 테이블 지우기 (테이블삭제는 롤백으로 안됨)

-- ---------------------
-- INSERT 3. (서브쿼리를 통해 얻어낸 데이터를 INSERT)
INSERT INTO managers
(SELECT employee_id, first_name, job_id, hire_date
FROM employees);        --employees에서 데이터 가져오기

-- ---------------------
-- UPDATE
CREATE TABLE emps AS (SELECT * FROM employees);     --다 복사하기

-- CTAS를 사용하면 제약조건은 NOT NULL말고는 복사되지 않습니다. -> 나머지규칙은 직접 넣어야한다.
-- (제약조건은 업무규칙을 지키는 데이터만 지정하고, 
-- 그렇지 않은 것들이 DB에 저장되는 것을 방지하는 목적으로 사용합니다.)

-- UPDATE를 진행할 떄는 누구를 수정할 지 잘 지목해야 합니다.
-- 그렇지 않으면 수정대상이 테이블 전체로 지목되기때문에...
UPDATE emps SET salary = 30000
WHERE employee_id = 100;

UPDATE emps SET salary = salary + salary*0.1 --10퍼 인상
WHERE employee_id = 100;

-- 여러개 할수있다. 
UPDATE emps SET
phone_number = '515.123.5677',
manager_id = 102
WHERE employee_id = 100;

-- UPDATE (서브쿼리)
UPDATE emps
    SET (job_id, salary, manager_id) =
    (SELECT job_id, salary, manager_id
    FROM emps
    WHERE employee_id = 100)
WHERE employee_id = 101;            -- 101번의 정보를 100번정보값으로 변경하기.

ROLLBACK;

-- ----------------
-- DELETE
DELETE FROM emps
WHERE employee_id = 103;            -- 103번 정보 삭제

-- DELETE (서브쿼리)
--(사본테이블 생성)
CREATE TABLE depts AS (SELECT * FROM departments);

DELETE FROM emps
WHERE department_id = (SELECT department_id FROM depts
                        WHERE department_id = 100);     -- 100번 부서 사람들 삭제

DELETE FROM emps
WHERE department_id = (SELECT department_id FROM depts 
                        WHERE department_name = 'IT');  -- IT 부서 사람들 삭제        
                                        