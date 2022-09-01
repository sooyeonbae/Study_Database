
-- 형 변환함수 TO_CHAR, TO_NUMBER, TO_DATE

-- **1) 날짜를 문자로 TO_CHAR (값, 형식)
SELECT TO_CHAR(sysdate) FROM dual; -- -> 형식:YY/MM/DD, 문자열로 인식
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD HH:MI:SS') FROM dual;
SELECT TO_CHAR(sysdate, 'YY-MM-DD HH24:MI:ss') FROM dual;
                    -- 연도 2자리, --24시간제, --초단위 그대로(초단위 대소문자 구분해야하는 경우도 있음)

-- 사용하고 싶은 문자를 ""로 묶어 전달합니다.
SELECT first_name, TO_CHAR(hire_date, 'YYYY"년" MM"월" DD"일"') -- 두번째 매개값은 서식형식으로만 넣어야한다.
                                            -- 서식문자 아닌것은 쌍따옴표로 묶어서 표기
FROM employees;

-- 2) 숫자를 문자로 TO_CHAR(값, 형식)
SELECT TO_CHAR(20000) FROM daul;    -- number타입이 문자타입으로 변환. 형식변동없다.
-- 주어진 자릿수에 숫자를 모두 표기할 수 없어서 모두 #으로 표기됩니다.
SELECT TO_CHAR(20000, '99,999') FROM dual;  -- ->20,000
SELECT TO_CHAR(20000, '9999') FROM dual; -- ->#####
SELECT TO_CHAR(20000.21, '99999.99') FROM dual;
            -- '9' : 숫자아니고 자리수를 표현하기위한 기호.더 작은 자리수가 들어가면 표기할수없는 숫자라서 #####으로 대체된다.

SELECT TO_CHAR(salary, 'L99,999') AS salary
FROM employees;         -- -> 시스템설정된 나라 화폐단위기준으로.

-- 3) 문자를 숫자로 TO_NUMBER(값, 형식)
SELECT '2000' + 2000 FROM dual; -- java는 20002000 되지만... 오라클은 4000 된다. (순수한 숫자는 자동형변환 가능)
SELECT TO_NUMBER('2000') + 2000 FROM dual; -- 명시적 형변환

SELECT '$3,300' + 2000 FROM dual; -- 오류
SELECT TO_NUMBER('$3,300', '$9,999') + 2000 FROM dual;
                            -- 숫자의 형식 설명

-- **4) 문자를 날짜로 변환하는 함수 TO_DATE(값, 형식)
-- (웹에서 날짜선택 받을 때 문자로 받게 됨 -> TO_DATE로 활용)
SELECT TO_DATE('2021-11-25') FROM dual; -- 기본형태
SELECT sysdate - TO_DATE('2021-03-25') FROM dual; -- 날짜로 변환해야 연산이 가능하다.
SELECT TO_DATE('2020/12/25', 'YY-MM-DD') FROM dual; -- 날짜타입의 형식을 지정해주기

-- 주어진 문자열을 모두 변환해야 합니다.
SELECT TO_DATE('2021-03-31 12:23:50', 'YYYY-MM-DD') FROM dual; -- error. 모든 형태를 작성해줘야 변환된다. 임의로 삭제불가능
SELECT TO_DATE('2021-03-31 12:23:50', 'YYYY-MM-DD HH:MI:SS') FROM dual;

-- 미니문제 (XXXX년 XX월 XX일 문자열 형식으로 변환해보세요. 조회컬럼명은 dateInfo로 하겠습니다.)
SELECT TO_CHAR(TO_DATE('20050102', 'YYYY/MM/DD'), 'YYYY"년" MM"월" DD"일"') AS dateInfo FROM dual;


-- NULL 변환 함수 (null값을 원하는 값으로) (null이 있으면 연산이 안된다.) 
-- NVL(컬럼, 변환할 타겟값)
SELECT null FROM dual;
SELECT NVL(null, 0) FROM dual; -- null을 0으로 변경
SELECT first_name, NVL(commission_pct, 0) AS comm_pct FROM employees;
                    -- commission 컬럼의 null들을 0으로 표기하겠다.

-- NULL 제거함수 NVL2(컬럼, null이 아닐경우의 값, null일 경우의 값) (상황에 따라 사용)
SELECT NVL2(50, '널아님', '널임') FROM dual; 
SELECT NVL2(null, '널아님', '널임') FROM dual; 

SELECT first_name, NVL2(commission_pct, 'true', 'false') FROM employees;

SELECT
    first_name, 
    commission_pct, 
    NVL2(commission_pct, salary+(salary*commission_pct), salary) AS real_salary
            --commission_pct가 null이 아니면 성과금더한거, null이면 그냥 salary
FROM employees;


-- DECODE(컬럼 혹은 표현식, 항목1, 결과1, 항목2, 결과2, ... default) (switch-case-default와 비슷)
SELECT
    DECODE('A', 'A', 'A입니다', 'B', 'B입니다', 'C', 'C입니다', '모르겠는데요')
FROM dual;

SELECT
    first_name
    job_id,
    salary,
    DECODE(job_id, 'IT_PROG', salary*1.1, 'FI_MGR', salary*1.2, 'AD_VP', salary*1.3, salary) AS result
            -- job_id가 IT_PROG면 임금이 1.1배 . . .                                    -- 해당안되면 그냥 salary
FROM employees;


-- CASE WHEN THEN END (if-swicth랑 더 비슷) (WHEN 갯수 제한 없다.)
SELECT
    first_name,
    job_id,
    salary,
    (CASE job_id
        WHEN 'IT_PROG' THEN salary*1.1
        WHEN 'FI_MGR' THEN salary*1.2
        WHEN 'FI_ACCOUNT' THEN salary*1.3
        WHEN 'AD_VP' THEN salary*1.4
        ELSE salary     -- 나머지는 그냥 salary
    END) AS result      -- ~끄읕~
FROM employees;



-- 연습문제
-- 01.
SELECT
    employee_id AS 사원번호,
    CONCAT(first_name, last_name) AS 사원명,
    hire_date AS 입사일자,
    TRUNC((sysdate - hire_date)/365) AS 근속년수
FROM employees
WHERE (sysdate - hire_date)/365 >= 15
--  그냥 근속년수(별칭)로 쓰면 안됨. invalid identifier. . . (SELECT가 마지막에 실행되기때문에 아직 식별되지 않은상태)
ORDER BY 근속년수 DESC;
-- SQL 실행순서) FROM - WHERE - SELECT - ORDER BY(무조건마지막)

-- 02.
SELECT
    first_name,
    manager_id,
    (CASE manager_id
        WHEN 100 THEN '사원'
        WHEN 120 THEN '주임'
        WHEN 121 THEN '대리'
        WHEN 122 THEN '과장'
        ELSE '임원'
    END) AS 직급
    -- DECODE 버전 :
    -- DECODE(manager_id, 100, '사원', 120, '주임', 121, '대리', 122, '과장', '임원') AS 직급
FROM employees
WHERE department_id = 50;