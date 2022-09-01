-- ** sequence (순차적으로 증가하는 값을 만들어 주는 객체) - 주로 기본키 값을 생성하기 위해 사용합니다.  ex.글번호,회원번호
-- MySQL은 시퀀스 없음 - AUTO INCREMENT

-- 조회 방법
SELECT * FROM user_sequences;

-- 시퀀스 생성 (괄호없고 콤마 없음)
CREATE SEQUENCE dept2_seq   -- 이름은 관례
    START WITH 1 -- 시작값 (기본값은 증가할때는 최소값, 감소할때는 최대값으로 자동지정)
    INCREMENT BY 1 -- 증가값 (양수면 증가, 음수면 감소, 기본값은 1)
    MAXVALUE 10 -- 최대값 (기본값은 증가일 때 1027, 감소일 때 -1)
    MINVALUE 1 -- 최소값 (기본값은 증가일 때 1, 감소일 때 -1028)
    NOCACHE -- 캐시메모리 사용여부 (기본값은 CACHE. 미리 일정 메모리를 떼어서 준비해둘수있음. 에러나면 중반번호 뜰 수 있음)
    NOCYCLE;    -- 순환여부 (기본값은 NOCYCLE, 순환시키려면 CYCLE.     NOCYCLE : MAX가 끝나면 seq가 끝난다. 계속 MAX값)

-- 예시
CREATE TABLE dept3 (
    dept_no NUMBER(2),
    dept_name VARCHAR2(14),
    loca VARCHAR2(13),
    dept_date DATE
);

-- SEQUENCE는 ALTER아니고 바로 RENAME 쓰면 된다.
RENAME dept2_seq TO dept3_seq;

-- 시퀀스 사용하기 (NEXTVAL, CURRVAL)
INSERT INTO dept3
VALUES (dept3_seq.NEXTVAL, 'test', 'test', sysdate); -- dept3_seq.NEXTVAL dept3_seq 시퀀스의 다음값
-- . . . 10까지의 사이클을 다 채우면 error뜬다.

SELECT dept3_seq.CURRVAL FROM dual; -- current value(현재 갖고있는 값 조회하기)



-- 시퀀스 수정하기 (직접 수정 가능)
-- START WITH는 수정이 불가능합니다.
ALTER SEQUENCE dept3_seq MAXVALUE 9999;   -- 최대값 변경
ALTER SEQUENCE dept3_seq INCREMENT BY -1; -- 증가값 변경
ALTER SEQUENCE dept3_seq MINVALUE -10; --최소값 변경

-- 시퀀스 값 초기화하는 방법 1)인크리먼트로 값 내리기, 2)시퀀스를 새로만들기
-- 1)
SELECT dept3_seq.CURRVAL FROM dual;
ALTER SEQUENCE dept3_seq INCREMENT BY -10; -- 지금 시퀀스 값만큼 깎아주기
SELECT dept3_seq.NEXTVAL FROM dual;
ALTER SEQUENCE dept3_seq INCREMENT BY 1; -- 다시 1부터. . .

-- 2)
DORP SEQUENCE dept3_seq;
-- CREATE로 새로만들기


-- -------------
/*
- index 
index는 primary key, unique 제약 조건에서 자동으로 생성되고,
조회를 빠르게 해 주는 hint 역할을 합니다.
index는 조회를 빠르게 하지만, 무작위하게 많은 인덱스를 생성해서 사용하면 오히려 성능 부하를 일으킬 수 있습니다.
정말 필요할 때에만 index를 사용하는 것이 올바릅니다.
*/

SELECT * FROM employees WHERE first_name = 'Nancy';

-- 인덱스 추가
CREATE INDEX emp_first_name_idx ON employees(first_name);
SELECT * FROM employees WHERE first_name = 'Nancy'; -- 실행계획,operation이 달라졌고, 속도도 단축됨

-- 인덱스 삭제
DROP INDEX emp_first_name_idx;

/*
- 인덱스가 권장되는 경우 
1. 컬럼이 WHERE 또는 조인조건에서 자주 사용되는 경우
2. 열이 광범위한 값을 포함하는 경우
3. 테이블이 대형인 경우
4. 타겟 컬럼이 많은 수의 null값을 포함하는 경우.
5. 테이블이 자주 수정되고, 이미 하나 이상의 인덱스를 가지고 있는 경우에는
 권장하지 않습니다.
6. 조회 결과가 전체 데이터의 15%를 넘는 경우 풀스캔보다 이점 없다.
*/


-- -------------
-- 시퀀스와 인덱스를 사용하는 hint 방법
CREATE SEQUENCE board_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE tbl_board (
    bno NUMBER(10) PRIMARY KEY, --primary key 지정하면 알아서 index 지정된다.
    writer VARCHAR2(20)
);

INSERT INTO tbl_board
VALUES (board_seq.NEXTVAL, 'test');
INSERT INTO tbl_board VALUES (board_seq.NEXTVAL, 'admin');
INSERT INTO tbl_board VALUES (board_seq.NEXTVAL, 'hong');
INSERT INTO tbl_board VALUES (board_seq.NEXTVAL, 'kim');
INSERT INTO tbl_board VALUES (board_seq.NEXTVAL, 'test');
INSERT INTO tbl_board VALUES (board_seq.NEXTVAL, 'admin');
INSERT INTO tbl_board VALUES (board_seq.NEXTVAL, 'hong');
INSERT INTO tbl_board VALUES (board_seq.NEXTVAL, 'kim');        -- 이거를 여러번 넣어주기...

COMMIT;

-- 인덱스 이름 변경
ALTER INDEX SYS_C007041 -- 선생님인덱스이름.  내거로 다시바꿔서확인해야한다.
RENAME TO tbl_board_idx;

SELECT * FROM
    (
    SELECT
        ROWNUM AS rn,
        bno,
        writer
    FROM tbl_board
    )
WHERE rn > 10 AND rn <= 20;

-- hint 주기 (/* */이용)
-- /*+ INDEX(table_name, index_name)*/
-- : 지정된 인덱스를 강제로 쓰게끔 지정하기
-- INDES ASC, DESC를 추가해서 내림차, 오름차 순으로 쓰게끔 지정도 가능.
SELECT * FROM
    (
    SELECT /*+ INDEX_DESC(tbl_board tbl_board_idx)*/    -- 오라클에게 힌트주기
        ROWNUM AS rn,
        bno,
        writer
    FROM tbl_board
    )
WHERE rn > 10 AND rn <= 20;