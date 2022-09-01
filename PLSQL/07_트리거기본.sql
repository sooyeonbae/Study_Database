-- 미리 만들어두고 일정조건이 만족되면 발동되도록 만든 것. 유지보수에 어려움이 있으니 남발은 X

/*
Trigger는 테이블에 부착한 형태로써,
INSERT, UPDATE, DELETE 작업이 수행될 때
특정 코드가 작동되도록 하는 구문입니다.
*/

CREATE TABLE tbl_test(
    id NUMBER(10),
    text VARCHAR2(20)
);
-- trigger 붙이기
CREATE /*(OR REPLACE )*/ TRIGGER trg_test
    AFTER DELETE OR UPDATE -- 삭제, 수정 이후에 동작하라
    ON tbl_test -- 부착할 테이블
    FOR EACH ROW -- 각 행에 적용해라
BEGIN 
    DBMS_OUTPUT.PUT_line('트리거가 동작했다.'); -- 트리거가 실행할 코드를 BEGIN~END 사이에 넣으면 된다.
END;

INSERT INTO tbl_test VALUES (1,'홍길동');
UPDATE tbl_test SET text='홍길동투' WHERE id=1;