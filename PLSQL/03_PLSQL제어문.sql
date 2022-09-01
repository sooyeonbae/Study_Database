-- IF문
DECLARE
    v_num1 NUMBER := 10;
    v_num2 NUMBER := 5;
BEGIN
    IF
        v_num1 >= v_num2
    THEN
        DBMS_OUTPUT.PUT_line(v_num1 || '이(가) 큰 수');
    ELSE
        DBMS_OUTPUT.PUT_line(v_num2 || '이(가) 큰 수');
    END IF;     -- IF문 끝난다고 말해주기

END;


-- ELSIF문 (오타아님)
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
BEGIN
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10,120), -1); -- DBMS_RANDOM.VALUE(범위) : 랜덤
                                                    -- ROUND -1  : 1의자리를 떼고 10단위 수를 만들기위해 -1에서 반올림
    SELECT salary 
    INTO v_salary
    FROM employees
    WHERE department_id = v_department_id;
    AND ROWNUM = 1; -- 첫째값만 구해서 변수에 저장하기위해.

    DBMS_OUTPUT.PUT_line(v_salary);

    IF v_salary <= 5000 THEN
        DBMS_OUTPUT.PUT_line('낮음');
    ELSIF v_salary <= 9000 THEN
        DBMS_OUTPUT.PUT_line('중간');
    ELSE
        DBMS_OUTPUT.PUT_line('높음');
    END IF;
END;



-- CASE문
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
BEGIN
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10,120), -1);
    SELECT salary 
    INTO v_salary
    FROM employees
    WHERE department_id = v_department_id;
    AND ROWNUM = 1;

    DBMS_OUTPUT.PUT_line(v_salary);
    CASE    -- CASE 시작합니다.
    WHEN v_salary <= 5000 THEN
        DBMS_OUTPUT.PUT_line('낮음');
    WHEN v_salary <= 9000 THEN
        DBMS_OUTPUT.PUT_line('중간');
    ELSE    -- 마지막은 ELSE
        DBMS_OUTPUT.PUT_line('높음');
    END CASE;
END;



-- 중첩 IF문 (IF문 안에 IF문)
DECLARE
    v_salary NUMBER := 0;
    v_department_id := 0;
    v_commission NUMBER := 0;
BEGIN
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
    
    SELECT salary, commission_pct
    INTO v_salary, v_commission
    FROM employees
    WHERE department_id = v_department_id
    AND ROWNUM = 1;

    DBMS_OUTPUT.PUT_line(v_salary);

    IF v_commission > 0 THEN
        IF v_commission > 0.15 THEN     -- 중첩 IF
            DBMS_OUTPUT.PUT_line(v_salary * v_commission);
        END IF; -- IF 단독으로 사용하고 ELSE 생략 가능.
    ELSE
        DBMS_OUTPUT.PUT_line(v_salary);
    END IF; -- 안쪽 IF문, 바깥쪽 IF문 다 닫아줘야한다.
END;