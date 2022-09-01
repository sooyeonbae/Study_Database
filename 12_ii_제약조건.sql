
-- 테이블 생성과 제약조건

-- 테이블 열레벨 제약조건 (CEHCK 빼고)
-- 1) PRIMARY KEY : 테이블의 고유 식별 컬럼 (주요 키). 테이블 당 하나정도는 존재하도록한다.
-- 2) UNIQUE : 유일한 값을 갖게 하는 컬럼 (중복값 방지)
-- 3) NOT NULL : null을 허용하지 않음 (필수값)
-- 4) FOREIGN KEY : 참조하는 테이블의 PRIMARY KEY를 저장하는 컬럼. (테이블간의 관계를 맺어준다. 문법엄격)
--               삭제 등에 번거로움. ex.게시글에 달린 댓글들. 댓글을 먼저 다 삭제해야 게시글 삭제가능기능
-- 5) CHECK : 정의된 형식만 저장되도록 허용.

/*
not null : null값은 안된다.
unique key :  null 허용
primary key : null 허용X , not null + unique. ->테이블에 하나정도는 존재해야한다.
foreign key : 외래키 (join 할 때 이어지는컬럼). 데이터 못지우게됨...
check : 참이어야하는 조건

제약조건 조회 : SELECT * FROM user_constraints;
*/

DROP TABLE dept2;

-- 제약조건 걸어서 테이블 만들기
CREATE TABLE dept2 (
    dept_no NUMBER(2) CONSTRAINT dept2_deptno_pk PRIMARY KEY,   -- 정석문법(나중에 속성 변경,삭제가능), 이름은 관례로
                    --그냥 PRIMARY KEY 라고만 적어도됨
    dept_name VARCHAR2(14) NOT NULL CONSTRAINT dept2_deptname_uk UNIQUE,
                        -- not null은 이름 지어주지 않는 편
                        -- UNIQUE + NOT NULL : PRIMARY와 기능 같음
    loca NUMBER(4) CONSTRAINT dept2_loca_locid_fk REFERENCES locations(location_id),
                                -- locations테이블의 location_id 컬럼값을 참조하는 외래키다.
                                -- 관계를 맺기로 한 테이블의 컬럼에 부모키가 있어야한다.
    dept_bonus NUMBER(10),
    dept_gender VARCHAR2(1) CONSTRAINT dept2_gender_ck CHECK(dept_gender IN ('M','F'))
                                                                    -- M 또는 F 만 가능
);

DROP TABLE dept2;

-- 테이블레벨 제약조건 (모든 열 선언 후 제약조건을 취하는 방식)
CREATE TABLE dept2 (
    dept_no NUMBER(2),
    dept_name VARCHAR2(14) NOT NULL,
    loca NUMBER(4),
    dept_date DATE,
    dept_bonus NUMBER(10),
    dept_gender VARCHAR2(1),

    CONSTRAINT dept2_deptno_pk PRIMARY KEY (dept_no),
    CONSTRAINT dept2_deptname_uk UNIQUE (dept_name),
    CONSTRAINT dept2_loca_locid_fk FOREIGN KEY (loca) REFERENCES locations(location_id),
                                    -- 여기서는 FOREIGN KEY 명시해줌
    CONSTRAINT dept2_deptdate_uk UNIQUE (dept_date),
    CONSTRAINT dept2_gender_ck CHECK(dept_gender IN('M','F'))                            
);

-- --------------
-- 외래키(FOREIGN KEY)가 부모테이블에 없다면 INSERT가 불가능하다.
INSERT INTO dept2
VALUES (10, 'gg', 4000, sysdate, 100000, 'M'); --error. location_id에 4000값이 없어서.

-- 외래키가 부모테이블에 있다면 INSERT 가능
INSERT INTO dept2
VALUES (10, 'gg', 2000, sysdate, 100000, 'M'); -- 가능

-- UNIQUE, PRIMARY 중복된거로 또 넣으려하면 error 뜬다.

-- 제약조건은 UPDATE 할때에도 작동한다.
UPDATE dept2 SET loca = 4000
WHERE loca = 2000;              -- error. location_id에 4000값이 없어서.

UPDATE locations SET location_id = 4000
WHERE location_id = 2000;               -- error. 참조하고 있는 애가 있어서 못바꿔주겠다.

-- -----------------
-- 제약조건 번경
-- 제약조건은 추가, 삭제가 가능하지만 변경은 불가능하다.
-- 그래서 변경하려면 삭제하고 새로운 내용으로 추가해야한다.

DROP TABLE dept2;

CREATE TABLE dept2 (
    dept_no NUMBER(2),
    dept_name VARCHAR2(14) NOT NULL,
    loca NUMBER(4),
    dept_date DATE,
    dept_bonus NUMBER(10),
    dept_gender VARCHAR2(1)
);

-- 이미 생성된 테이블에 제약조건 걸어주기.
-- pk추가
ALTER TABLE dept2 ADD CONSTRAINT dept2_deptno_pk PRIMARY KEY(dept_no);
-- fk추가
ALTER TABLE dept2 ADD CONSTRAINT dept2_loca_locid_fk
FOREIGN KEY(loca) REFERENCES locations(location_id);
-- check추가
ALTER TABLE dept2 ADD CONSTRAINT dept2_gender_ck CHECK(dept_gender IN ('M','F'));
-- unique추가
ALTER TABLE dept2 ADD CONSTRAINT dept2_deptdate_uk UNIQUE(dept_date);
ALTER TABLE dept2 ADD CONSTRAINT dept2_deptname_uk UNIQUE(dept_name);

-- NOT NULL 추가하기는 조금 다르다. 'MODIFY'
ALTER TABLE dept2 MODIFY dept_date DATE NOT NULL;   -- 열 속성 변경하는 방식으로

-- 제약조건 삭제하기 (제약조건 이름으로)
ALTER TABLE dept2 DROP CONSTRAINT dept2_deptno_pk; -- 제약조건 이름으로 삭제해야한다.


-- (제약조건 확인 sql)
SELECT * FROM user_constraints WHERE table_name = 'DEPT2';



-- ----------------- 문제
-- 01
CREATE TABLE memebers (
    m_name VARCHAR2(20) NOT NULL,
    m_num NUMBER(3) CONSTRAINT mem_memnum_pk PRIMARY KEY,
    reg_date DATE NOT NULL CONSTRAINT meme_regdate_uk UNIQUE,
    gender VARCHAR2(5),
    loca NUMBER(4) CONSTRAINT mem_loca_loc_locid_fk REFERENCES locations(location_id)
);
COMMIT;

INSERT INTO members VALUES ('AAA', 1, '18/07/02', 'M', 1800);
INSERT INTO members VALUES ('BBB', 2, '18/07/01', 'F', 1900);
INSERT INTO members VALUES ('CCC', 3, '18/07/03', 'M', 2000);
INSERT INTO members VALUES ('DDD', 4, sysdate, 'M', 2000);


-- 02
SELECT m.m_name, m.m_num, loc.street_address, loc.location_id
FROM members m JOIN locations loc
ON m.loca = loc.location_id --foreign key로 묶으면 된다. 꼭은 아니구..
ORDER BY m.m_num ASC;