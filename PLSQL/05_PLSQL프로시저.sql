-- (여태까지 하던 것 : 익명블록)
-- 프로시저 : 비슷한데, 이름이 있다. 메서드랑 비슷

-- 프로시저 (procedure) -> void 메서드와 유사.
-- 특정한 로직을 처리하고 결과값을 반환하지 않는 코드 덩어리 (쿼리 덩어리).
-- PL/SQL에도 값을 전달받아서 코드를 실행 후 리턴하는 함수가 존재합니다.
-- 하지만 프로시저를 통해서도 값을 리턴하는 방법이 있습니다.



-- i) 매개값(인수) 없는 프로시저 (CREATE PROCEDURE... IS ... BEGIN... END)
CREATE PROCEDURE p_test
IS  -- 선언부
    v_msg VARCHAR2(30) := 'HELLO PROCEDURE!';
BEGIN -- 실행부
    DBMS_OUTPUT.PUT_line(v_msg);
END; -- 종료부 
-- 실행하면 컴파일되었다는 안내는 뜨지만, 바로 실행이 되지는 않는다. 불러야 실행이 된다 (메서드처럼)

EXEC p_test; -- 프로시저 호출문 (여기만 긁어서 F5누르면 된다)


-- ii) IN 입력값을 받는 파라미터 (수정 안됨) IN을 통해서야 BEGIN 단에서 활용이 가능하다.(활용하려면 IN으로 받아야한다.)
CREATE PROCEDURE my_new_job_proc
(
    p_job_id IN jobs.job_id%TYPE,       -- 괄호 안에 매개변수 받기
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE,
    p_max_sal IN jobs.max_salary%TYPE
)
IS
BEGIN
    INSERT INTO jobs
    VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    COMMIT;
END;

EXEC my_new_job_proc('JOB1', 'test job1', 1000, 5000); -- 호출. 이 프로시저를 부를땐 타입에 맞는 매개값을 다 넣어줘야한다.


-- iii) 프로시저 수정하기
CREATE OR REPLACE PROCEDURE my_new_job_proc -- CREATE OR REPLACE (이미 존재한다면 ALTER, 없다면 CREATE)
(
    p_job_id IN jobs.job_id%TYPE,  
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE,
    p_max_sal IN jobs.max_salary%TYPE
)
IS
    v_cnt NUMBER := 0;
BEGIN
    -- 동일한 job_id가 있는지부터 체크. 이미 존재한다면 1, 존재하지 않는다면 0 -> v_cnt에 대입할 예정
    SELECT COUNT(*) -- job_id가 매개값으로들어온 p_job_id와 같다면 숫자를 세서 v_cnt에 넣어주겠다.
    INTO v_cnt
    FORM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN   -- 없다면 INSERT 해라
        INSERT INTO jobs
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE -- 있다면 UPDATE 해라
        UPDATE jobs
        SET job_title = p_job_title,
            min_salary = p_min_sal,
            max_salary = p_max_sal
        WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;

EXEC my_new_job_proc('JOB2', 'test job2', 2000, 10000); -- 새로 넣기
EXEC my_new_job_proc('JOB2', 'test job2', 5000, 10000); -- 수정하기
-- 매개값 다 안들어가면 error 난다.


-- iv) 기본값 두고 매개값 안넣는 자리에 기본값 넣어주기
-- 매개변수 (인수)의 디폴트값 (기본값) 설정
CREATE OR REPLACE PROCEDURE my_new_job_proc
    p_job_id IN jobs.job_id%TYPE,  
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE := 0,     -- 기본값
    p_max_sal IN jobs.max_salary%TYPE := 1000
)
IS
    v_cnt NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_cnt
    FORM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN 
        INSERT INTO jobs
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE
        UPDATE jobs
        SET job_title = p_job_title,
            min_salary = p_min_sal,
            max_salary = p_max_sal
        WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;

EXEC my_new_job_proc('JOB2', 'test job2'); -- 값을 넣지 않은 곳에 기본값 0, 1000 으로 들어가게됨

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 값을 밖으로 빼기 (메서드의 return처럼) - OUT, IN OUT 매개변수(인수) 사용
-- OUT 변수를 사용하면 프로시저 바깥쪽으로 값으르 보냅니다.
-- OUT을 통해서 보낸 값은 바깥 익명블록에서 실행해야 합니다.

-- v) OUT
CREATE OR REPLACE PROCEDURE my_new_job_proc
    p_job_id IN jobs.job_id%TYPE,  
    p_job_title IN jobs.job_title%TYPE,
    p_min_sal IN jobs.min_salary%TYPE := 0, 
    p_max_sal IN jobs.max_salary%TYPE := 1000,
    p_result OUT VARCHAR2 -- 바깥쪽에서 출력을 하기 위한 변수 (값이 있었는지 없었는지 확인용). 
                            -- 프로시저가 끝나면 (return 키워드없이) 값이 알아서 나간다. (익명블록에서 받을준비해야한다.)
)
IS
    v_cnt NUMBER := 0;
    v_result VARCHAR2(100) := '값이 존재하지 않아서 INSERT로 처리 되었습니다.'; -- v_result에 메세지 넣어두기
BEGIN
    SELECT COUNT(*)
    INTO v_cnt
    FORM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN 
        INSERT INTO jobs
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);

    ELSE    -- 값이 존재한다면 결과추출해주기
        SELECT
            p_job_id/*매개값*/ || '의 최대 연봉 : ' || max_salary || ', 최소 연봉 : ' || min_salary
            INTO v_result -- 조회결과를 대입. 값이 존재한다면 위에 메세지로 수정됨
        FROM jobs
        WHERE job_id = p_job_id;
    END IF;
    
    -- OUT 매개변수에 결과를 할당하기
    p_result := v_result

    COMMIT;
END;

DECLARE -- 결과받는용 익명블록
    str VARCHAR2(100);
BEGIN
    -- 프로시저를 부를 때 OUT 되는 값을 받을 변수를 하나 더 전달해주셔야 합니다 : str
    my_new_job_proc('JOB1', 'test job1', 2000, 8000, str);
    DBMS_OUTPUT.PUT_line(str);

    my_new_job_proc('CEO', 'test_CEO', 10000, 100000, str);
    DBMS_OUTPUT.PUT_line(str);
END;


-- vi) IN OUT : IN, OUT을 동시에 처리한다. IN의 성질과 OUT의 성질 모두 가지고있다.
CREATE OR REPLACE PROCEDURE my_parameter_test_proc
(
    p_var1 IN VARCHAR2, -- IN : 반환 불가
    p_var2 OUT VARCHAR2,   -- OUT : 프로시저가 끝나기 전까지는 값의 할당이 안됨, 끝나야 OUT이 가능
    p_var3 IN OUT VARCHAR2  -- IN OUT : IN, OUT 둘 다 가능
)
IS
BEGIN
    DBMS_OUTPUT.PUT_line('p_var1 : ' || p_var1);    -- 출력 가능
    DBMS_OUTPUT.PUT_line('p_var2 : ' || p_var2);    -- 값이 전달이 안됐어요 (공백)
    DBMS_OUTPUT.PUT_line('p_var3 : ' || p_var3);    -- 출력 가능 (IN의 성질을 가지고 있다)
    -- value1, value3 : 잘 전달받고 활용가능 / value2 : 값을 받는 역할 못한다.

    -- p_var1 := '결과1'; -- error. 할당불가다. 새로운 값을 줄 수 없다. IN은 프로시저 호출할 때 보내준 값만 보내서 확인하는것만 가능.
    p_var2 := '결과2';
    p_var3 := '결과3';  -- IN OUT도 가능.

    DBMS_OUTPUT.PUT_line('- - - - - - - - - - - - - - - - - - - - - -')

END;

DECLARE
    v_var1 VARCHAR2(10) := 'value1';
    v_var2 VARCHAR2(10) := 'value2';
    v_var3 VARCHAR2(10) := 'value3';
BEGIN
    my_parameter_test_proc(v_var1, v_var2, v_var3);

    DBMS_OUTPUT.PUT_line('v_var1 : ' || v_var1);
    DBMS_OUTPUT.PUT_line('v_var2 : ' || v_var2);
    DBMS_OUTPUT.PUT_line('v_var3 : ' || v_var3);
END;



-- vii) RETURN (프로시저를 강제로 종료) (자바의 void메서드의 return과 비슷)
CREATE OR REPLACE PROCEDURE my_new_job_proc
(
    p_job_id IN jobs.job_id%TYPE,  
    p_result OUT VARCHAR2 
)
IS
    v_cnt NUMBER := 0;
    v_result VARCHAR2(100) := '값이 존재하지 않아서 INSERT로 처리 되었습니다.'; 
BEGIN
    SELECT COUNT(*)
    INTO v_cnt
    FORM jobs
    WHERE job_id = p_job_id;

    IF v_cnt = 0 THEN -- 조회결과 없으면 메세지 날리고 RETURN(프로시저를 강제로 종료)
        DBMS_OUTPUT.PUT_line(p_job_id || '는 테이블에 존재하지 않습니다.');
        RETURN;
    END IF;

    SELECT
        p_job_id || '의 최대 연봉 : ' || max_salary || ', 최소 연봉 : ' || min_salary
         INTO v_result
    FROM jobs
    WHERE job_id = p_job_id;
    
    p_result := v_result

    COMMIT;
END;

DECLARE 
    str VARCHAR2(100);  -- 값이 돌아올수도 있으니까 
BEGIN
    my_new_job_proc('CEO', str);    -- 존재하는 데이터라서 최대연봉,최소연봉 받아옴
    DBMS_OUTPUT.PUT_line(str);

    my_new_job_proc('STUDENT', str);    -- 조회할 게 없어서 SELECT 안하고 종료됨
    DBMS_OUTPUT.PUT_line(str);
END;


-- viii) 예외처리 (자바의 try-catch-(finally))
DECLARE
    v_num NUMBER := 0;
BEGIN
    v_num := 10/0;
EXCEPTION WHEN OTHERS THEN  -- 예외처리
    DBMS_OUTPUT.PUT_line('0으로 나눌 수 없습니다.');
    DBMS_OUTPUT.PUT_line('SQL ERROR CODE : ' || SQLCODE);   -- 에러코드
    DBMS_OUTPUT.PUT_line('ERROR MESSAGE : ' || SQLERRM);    -- 에러 메세지
    
END;