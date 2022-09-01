-- DDL : Data definition language
--    CREATE, ALTER, DROP, TRUNCATE

-- NUMBER(2) : 정수를 2자리까지 저장할 수 있는 숫자형 타입.
-- NUMBER(5,2) : 정수부, 실수부를 합친 총 자리수가 5자리고, 소수점 2자리까지 표현하겠다.
-- NUMBER : 괄호를 생략할 시 (38, 0)으로 자동 지정됩니다.
-- VARCHAR2(byte) : 괄호 안에 들어올 문자열의 최대 길이를 지정. (4000byte까지)
-- DATE : BC 4712년 1월1일~ AD 9999년 12월 31일까지 지정가능. (시, 분, 초 지원가능.)



CREATE TABLE dept2 (
    dept_no /* :컬럼명*/    NUMBER(2), /*:데이터타입(자리수)*/
    dept_name VARCHAR2(14), -- 괄호안 : 바이트 (최대4000)     -- MySQL:VARCHAR
    loca VARCHAR(15),
    dept_date DATE,
    dept_bonus NUMBER(10)
);

DESC dept2; -- 구조 조회

-- NUMBER 타입에 들어가는 자리수를 확인
INSERT INTO dept2
VALUES(10, '영업', '서울', sysdate, 200000000000);  --error. 자리수가 넘쳐서

-- 컬럼 추가
ALTER TABLE dept2
ADD (dept_count NUMBER(3));

-- 컬럼 이름 변경
ALTER TABLE dept2
RENAME COLUMN dept_count to emp_count;

-- 컬럼 속성 수정
ALTER TABLE dept2
MODIFY (emp_count NUMBER(4));

-- 컬럼 삭제
ALTER TABLE dept2
DROP COLUMN emp_count;

-- 테이블이름 변경
ALTER TABLE dept2
RENAME TO dept3;

-- 테이블 안 데이터 다 지우기(구조는 남겨두고) : TRUNCATE
TRUNCATE TABLE dept3;

-- 테이블 삭제
DROP TABLE dept3;       -- 이 페이지 안 모든 행동 ROLLBACK안됨!!