-- 트리거에는 after trigger(SQL->trigger)와 before trigger(trigger->SQL)가 있다.

/*
AFTER TRIGGER : INSERT, UPDATE, DELETE 작업 이후에 동작하는 트리거를 의미합니다. 
BEFORE TRIGGER : INSERT, UPDATE, DELETE 작업 이전에 동작하는 트리거를 의미합니다. 
INSTEAD OF TRIGGER : INSERT, UPDATE, DELETE 작업 이전에 발생하는 트리거인데, VIEW에만 부착할 수 있다.

:OLD  : 참조 전 열의 값 지목 (ex) INSERT에서는 입력 전 자료, UPDATE에서는 수정 전 자료, DELETE에서는 삭제할 값.
:NEW  : 참조 후 열의 값                         할 자료                 된 자료             사용하지않는다.
*/

CREATE TABLE tbl_user (
    id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(20),
    address VARCHAR2(30)
);

CREATE TABLE tbl_user_backup (
    id VARCHAR2(20),
    name VARCHAR2(20),
    address VARCHAR2(30)
    update_date DATE DEFAULT sysdate, -- 변경시간
    m_type VARCHAR2(10),    -- 변경 타입
    m_user VARCHAR2(20),    -- 변경한 사용자
)


-- i) AFTER 트리거
CREATE OR REPLACE TRIGGER trg_user_backup
    AFTER UPDATE OR DELETE
    ON tbl_user
    FOR EACH ROW
    -- 특정행에 걸기 : FOR EACH ROW WHERE . . .
DECLARE -- 사용할 변수를 선언하는 곳
    v_type VARCHAR2(10);
BEGIN
    IF UPDATING THEN    -- UPDATING : DB시스템 자체에서 상태에 대한 내용을 지원하는 빌트인 구문.
                        -- 지금 업데이트 진행하는 상황인가? 하고 물어보는중
        v_type := '수정';
    ELSIF DELETING THEN -- 지금 딜리트 진행하는 상황이면 v_type에 '삭제' 넣어라.
        v_type := '삭제';
    END IF;

    -- 실행구문 시작. (:OLD는 테이블 DELETE,UPDATE 전 기존데이터. 즉 변경 전 데이터를 집어넣겠다는 뜻.)
    INSERT INTO tbl_user_backup
    VALUES(:OLD.id, :OLD.name, :OLD.address, sysdate, v_type, USER());
END;

-- 트리거 동작 확인
INSERT INTO tbl_user VALUES ('test01', 'admin', '서울');
INSERT INTO tbl_user VALUES ('test02', '멍멍이', '서울');
INSERT INTO tbl_user VALUES ('test03', '야옹이', '서울');

SELECT * FROM tbl_user;
SELECT * FROM tbl_user_backup;

UPDATE tbl_user SET address='경기도' WHERE id='test01';

SELECT * FROM tbl_user;
SELECT * FROM tbl_user_backup;

-- 궁금한거 : 마지막꺼만 저장되는지 아니면 같은아이디여도 내역이 다 저장되는지?



-- ii) BEFORE 트리거
CREATE OR REPLACE TRIGGER trg_user_insert
    BEFORE INSERT
    ON tbl_user
    FOR EACH ROW
BEGIN
    :NEW.name := SUBSTR(:NEW.name, 1, 1) || '**'; -- 앞에 한글자 빼고 나머지는 * 처리 (김**)
END;

INSERT INTO tbl_user VALUES ('test04', '홍길동', '부산');

SELECT * FROM tbl_user;




/*
- 트리거의 활용
INSERT -> 주문테이블 -> 주문테이블 INSERT 트리거 실행 (물품테이블(재고수량) UPDATE)
*/

-- 주문 히스토리
CREATE TABLE order_history (
    history_no NUMBER(5) PRIMARY KEY,
    order_no NUMBER(5),
    product_no NUMBER(5),
    total NUMBER(10),   -- 재고
    price NUMBER(10)
);

-- 상품
CREATE TABLE product (
    product_no NUMBER(5) PRIMARY KEY,
    product_name VARCHAR2(20),
    total NUMBER(5),
    price NUMBER(5)
);

-- 시퀀스
CREATE SEQUENCE order_history_seq NOCACHE;
CREATE SEQUENCE product_seq NOCACHE;

INSERT INTO product VALUES (product_seq.NEXTVAL, '피자', 100, 10000);
INSERT INTO product VALUES (product_seq.NEXTVAL, '치킨', 100, 15000);
INSERT INTO product VALUES (product_seq.NEXTVAL, '햄버거', 100, 5000);

SELECT * FROM product;

-- 주문 히스토리에 데이터가 들어오면 실행
CREATE OR REPLACE TRIGGER trg_order_history
    AFTER INSERT
    ON order_history
    FOR EACH ROW
DECLARE
    v_total NUMBER;
    v_product_no NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_line('트리거 실행!');
    SELECT :NEW.total
    INTO v_total
    FROM dual;

    v_product_no := :NEW.product_no;
    
    UPDATE product
    SET total = total - v_total
    WHERE product_no = v_product_no;
END;

INSERT INTO order_history VALUES (order_history_seq.NEXTVAL, 200, 1, 5, 50000);
