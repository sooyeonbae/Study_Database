
-- 숫자함수

-- 1) ROUND : 반올림 (java, python에도 있음)
-- 원하는 반올림 위치를 매개값으로 지정, 음수를 주는 것도 가능
SELECT 
    ROUND(3.141592, 2),
    ROUND(45.923, 0),   -- 0번째자리까지 : 소수점 자르고 반올림
    ROUND(45.923, -1)   -- 음수 : 소수점 좌측의 자리에서 반올림
FROM dual;

-- 2) TRUNC (truncate. 절사) : 정해진 소수점 자리수까지 (반올림없이) 잘라냅니다.
SELECT
    TRUNC(3.141592, 3),
    TRUNC(45.923), 0),
    TRUNC(45.923, -1)
FROM dual;

-- 3) ABS (absolute) : 절대값
SELECT ABS(-34) FROM dual;

-- 4) CEIL : 올림, FLOOR : 내림
-- 소수점이 존재하면 올리거나 내림
SELECT CEIL(3.14), FLOOR(3.14)
FROM dual;

-- 5) MOD : 나머지
SELECT 10/2, MOD(10, 2) FROM dual;
      -- 몫     -- 나머지




-- 날짜함수
SELECT sysdate FROM dual;   -- 시스템의 날짜 불러오기(함수는 아니지만 함수로취급)
                            -- 사용예시) insert해서 게시글 작성일 입력
                            -- 시간도 숨어있어서 가져올 수 있다.
SELECT systimestamp FROM dual; -- 날짜+시간정보 (+GMT:표준시차..?) 잘 안쓴다.

-- 날짜도 연산이 가능합니다.
SELECT first_name, sysdate - hire_date
FROM employees;         -- 오늘날짜-입사일 : 일한지 며칠됐는지

SELECT first_name, hire_date,
(sysdate - hire_date) / 7 AS week -- (오늘날짜-입사일)/7 : 일한지 몇 주 됐는지
FROM employees;

SELECT first_name, hire_date,
(sysdate - hire_date) / 365 AS year -- (오늘날짜-입사일)/365 : 일한지 몇 년 됐는지
FROM employees;

-- 날짜 반올림, 절사
SELECT ROUND(sysdate) FROM dual; -- 그냥 sysdate와 같음
-- 날짜는 키워드로 반올림한다.
SELECT ROUND(sysdate, 'year') FROM dual; -- 해당 연도의 1월 1일 (상반기:올해, 하반기:내년)
SELECT ROUND(sysdate, 'month') FROM dual; -- 해당 달의 반이 넘어가면 다음달 1일
SELECT ROUND(sysdate, 'day') FROM dual; -- 기준:해당 주의 일요일날짜(일주일의 반이 넘으면 다음주 일요일날짜 출력된다.)
--절사
SELECT TRUNC(sysdate) FROM dual;
SELECT TRUNC(sysdate, 'year') FROM dual; -- 해당 연도의 1월 1일 (연말이어도)
SELECT TRUNC(sysdate, 'month') FROM dual; -- 해당 달의 1일
SELECT TRUNC(sysdate, 'day') FROM dual; -- 지난 일요일
