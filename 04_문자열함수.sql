
-- lower(소문자), initcap(앞글자만 대문자) upper(대문자)

/*
dual이라는 테이블은 sys가 소유하는 오라클의 표준 테이블로서,
 오직 한 행에 한 컬럼만 담고 있는 dummy 테이블이다.
 일시적인 산술 연산이나 날짜 연산 등을 주로 사용한다.
 모든 사용자가 접근할 수 있다.
*/
SELECT 'abcDEF', lower('abcDEF'), upper('abcDEF')
FROM dual;

SELECT last_name, lower(last_name), INITCAP(last_name), upper(last_name)
FROM employees;

SELECT last_name FROM employees
WHERE lower(last_name) = 'austin';

-- length(길이), instr(문자 찾기. 없으면 0값 나옴, 인덱스값.)
SELECT 'abcdef' AS ex, LENGTH('abcdef'), INSTR('abcdef', 'a')
FROM dual;

SELECT first_name, LENGTH(first_name), INSTR(first_name, 'a')
FROM employees;

-- substr(문자열 자르기)(begin index, end index), concat(문자 연결) 1부터 시작 오라클에서는 2개만연결가능
SELECT 'abcdef' AS ex,
SUBSTR('abcdef', 1, 4), CONCAT('abc', 'def')
FROM dual;

SELECT first_name, SUBSTR(first_name, 1, 3),
CONCAT(first_name, last_name)
FROM employees;

-- LPAD, RPAD (좌, 우측 지정문자열로 채우기)
SELECT LPAD('abc', 10, '*') FROM dual;
SELECT RPAD('abc', 10, '*') FROM dual;


-- ======================04/22========================

-- LTRIM(), RTRIM(), TRIM() (java의 String 클래스의 Trim과 같은기능) : 공백제거
-- LTRIM RTRIM - java에서는 공백제거, 오라클에서는 문자열제거.
-- LTRIM : 왼쪽에 있는 문자열제거, RTRIM : 오른족에 있는 문자열 제거.
SELECT TRIM ('   JAVA     ') FROM dual;
SELECT LTRIM('javascript_java', 'java') FROM dual;
                                -- 제거할 문자열
SELECT RTRIM('javascript_java', 'java') FROM dual;

-- **REPLACE() (java의 String 클래스의 Trim과 같은기능)
SELECT REPLACE('My dream is a president', 'president', 'doctor') FROM dual;
                                        -- 기존 문자열      -- 변경해서 넣을 새 문자열
SELECT REPLACE('My dream is a president', ' ', '') FROM dual; -- 공백지우기
                                        -- 공백을 없애겠다.
-- 함수 안 함수 가능하다.-- (이건 자바에서도 적용가능하다. void는 안되지만)
SELECT REPLACE(REPLACE('My dream is a president', 'president', 'doctor'), ' ','') FROM dual;
-- REPLACE 안에 REPLACE - 바깥쪽 REPLACE의 매개변수가 안쪽REPLACE함수의 리턴값. 안쪽부터 해석하면 된다.
SELECT REPLACE(CONCAT('hello ', 'world!'), '!', '?') FROM dual;


-- 각 함수의 매개변수 조건을 잘 기억하자!!!


-- =======연습문제=======
-- 03.
SELECT 
    RPAD(SUBSTR(first_name, 1, 3) , length(first_name), '*') AS name,
    LPAD(salary, 10, '#') AS salary
FROM employees
WHERE LOWER(job_id) = 'it_prog';

-- 01.
SELECT
    CONCAT(first_name, last_name) AS name,
    REPLACE(hire_date, '/', '')
FROM employees
ORDER BY name ASC;

-- 02.
SELECT REPLACE(phone_number, SUBSTR(phone_number, 1, 4), '(02)')
FROM employees;
-- 선생님코드
SELECT
CONCAT ('(02)', SUBSTR(phone_number, 4, LENGTH(phone_number))) AS phone_number
FROM employees;









