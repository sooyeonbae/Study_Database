-- WHILE문

DECLARE
    v_num NUMBER := 3;
    v_count NUMBER := 1;
BEGIN
    WHILE v_count <= 10
    LOOP
        DBMS_OUTPUT.PUT_line(v_num);
        v_count := v_count+1;
    END LOOP;
END;



-- 탈출문
DECLARE
    v_num NUMBER := 3;
    v_count NUMBER := 1;
BEGIN
    WHILE v_count <= 10
    LOOP
        DBMS_OUTPUT.PUT_line(v_num);
        EXIT WHEN v_count = 5;  -- 탈출문 : EXIT
        v_count := v_count+1;
    END LOOP;
END;



-- FOR문
DECLARE
    v_num NUMBER := 3;
BEGIN
    FOR i IN 1..9  -- .. : 범위표현
    LOOP
        DBMS_OUTPUT.PUT_line(v_num || 'x' || i || '=' || v_num * i);
    END LOOP;
END;


-- CONTINUE문
DECLARE
    v_num NUMBER := 3;
BEGIN
    FOR i IN 1..9
    LOOP
        CONTINUE WHEN i = 5;    -- i가 5인 회차만 건너뛰고 진행하겠다.
        DBMS_OUTPUT.PUT_line(v_num || 'x' || i || '=' || v_num * i);
    END LOOP;
END;


-- 1. 모든 구구단을 출력하는 익명 블록을 만드세요. (2~9단) -- 중첩반복문(LOOP 안에  LOOP)

DECLARE
    n NUMBER := 2; -- 단
    m NUMBER := 1;
BEGIN
    FOR n IN 2..9
    LOOP
        DBMS_OUTPUT.PUT_line( '***' || n || '단 ***')
            FOR m IN 1..9
            LOOP
                DBMS_OUTPUT.PUT_line(n || 'X' || m || '=' || n*m);
            END LOOP;
    END LOOP;
END;
            
-- 선생님코드 (DECLARE 없이)
BEGIN
    FOR dan IN 2..9
    LOOP
        DBMS_OUTPUT.PUT_line('구구단 : '|| dan || '단');
        FOR hang in 1..9
        LOOP
            DBMS_OUTPUT.PUT_line(dan || 'X' || hang || '=' || dan*hang);
        END LOOP
        DBMS_OUTPUT.PUT_line('----------------------');
    END LOOP;
END;




-- 2. INSERT를 300번 실행하는 익명 블록을 처리하세요.
-- board라는 이름의 테이블을 만드세요. (bno, writer, title 컬럼이 존재한다.)
-- bno는 SEQUENCE로 올려 주시고, writer와 title에 번호를 붙여서 INSERT 진행해 주세요.
-- ex) 1, test1, title1 -> 2 test2 title2 -> 3 test3 title3...

CREATE TABLE board (
    bno NUMBER PRIMARY KEY,
    writer VARCHAR2(30),
    title VARCHAR2(30)
)

CREATE TABLE board_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 1000;

DECLARE
    writer VARCHAR2
    title VARCHAR2
BEGIN
    FOR i IN 1..300
    LOOP
    INSERT INTO board
        (bno, writer, title)
        VALUES 
        (seq, 'writer'||i , 'title'||i)
        i = i+1;
    LOOP END;
END;

-- 선생님코드
CREATE TABLE board (
    bno NUMBER PRIMARY KEY,
    writer VARCHAR2(30),
    title VARCHAR2(30)
)

CREATE TABLE b_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 1000
    NOCYCLE
    NOCACHE;

DECLARE
    v_num NUMBER := 1;
BEGIN
    WHILE v_num <= 300
    LOOP
        INSERT INTO board
        VALUES (b_seq.NEXTVAL, 'writer'||v_num, 'title'||v_num)
        v_num := v_num+1;
    END LOOP;
END;

SELECT * FROM board
ORDER BY bno DESC;