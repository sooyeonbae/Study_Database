-- 1. 구구단 중 3단을 출력하는 익명 블록을 만들어 보자 (출력문 9개를 복사해서 쓰세요.)

DECLARE
    n NUMBER;
    M NUMBER;
BEGIN
    if (n < 10) {}
    n := 1;
    m := 3*n;
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
    n++;
    }
END;

-- 선생님코드
BEGIN   -- DECLARE 필요없으면 안써도된다.
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
    DBMS_OUTPUT.PUT_line(3 || '*' || n || '='|| m )
END;



-- 2. 사원 테이블에서 201번 사원의 이름과 이메일주소를 출력하는 익명 블록을 만들어 보자
-- 변수에 담아서 출력하세요.

DECLARE
    emp_name VARCHAR2(20);  -- employees.first_name%TYPE
    emp_email VARCHAR2(50); -- employees.email%TYPE
BEGIN
    SELECT first_name, email
    INTO emp_name, emp_email
    FROM employees
    WHERE employee_id = 201;

    DBMS_OUTPUT.PUT_line(emp_name || '-' || emp_email)
END;


-- 3. 사원 테이블(employees)에서 사원번호가 제일 큰 사원을 찾아낸 뒤 (MAX 함수 사용),
-- 이 번호 + 1번으로 아래의 사원을 emps에
-- employee_id, last_name, email, hire_date, job_id를 신규 입력하는 익명 블록을 만드세요.
-- SELECT절 이후에 INSERT문 사용이 가능합니다.
/*
<사원명>: steven
<이메일>: stevenjobs
<입사일자>: 오늘날짜
<JOB_ID>: CEO
*/
DROP TABLE emps;
CREATE TABLE emps AS (SELECT * FROM employees WHERE 1 = 2);

DECLARE
    emp_name VARCHAR2(20) := 'steven';
    emp_email VARCHAR2(50) := 'stevenjobs';
    emp_hireDate DATE := SYSDATE;
    emp_jobId VARCHAR2(20) := 'CEO';
BEGIN
    INSERT INTO emps
        (employee_id, last_name, email, hire_date, job_id)
    VALUES
        (SELECT
            employee_id
            FROM employees
            WHERE MAX(employee_id)
        )+1, emp_name, emp_email, emp_hireDate, emp_jobId;
END;

-- 변수 선언할 때 최대숫자 찾아내고 1 넣어라
emp_employeeId := (SELECT
            employee_id
            FROM employees
            WHERE MAX(employee_id)) +1;

-- 선생님코드
DECLARE
    v_max_empno employees.employee_id%TYPE -- 변수는 이것만
BEGIN
    SELECT MAX(employee_id)
    INTO v_max_empno
    FROM employees; -- MAX 이용해서 변수에 값 넣어두기

    INSERT INTO emps
        (employee_id, last_name, email, hire_date, job_id)
    VALUES
        (v_max_empno+1, 'steven', 'stevenjobs', SYSDATE, 'CEO'); -- max번호에 1 더한값으로 넣기
    COMMIT;
END;