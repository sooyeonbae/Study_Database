
-- 사용자 계정 확인
SELECT * FROM all_users;

-- 계정 생성 명령
CREATE USER user1 IDENTIFIED BY user1;  -- 권한이 불충분하다고 error...
            -- ID               -- 비밀번호

-- SQL Developer 가서 초록색플러스아이콘 - 계정 등록하기
-- Name, 사용자이름 : system, 비밀번호: oracle
-- test -> 상태성공 확인
-- 저장

-- system 계정으로 접속하기
-- system 계정상태에서 다시 계정생성 명령
CREATE USER user1 IDENTIFIED BY user1;

-- DCL : Data Control Language - GRANT(권한 부여), REVOKE(권한 회수)
/*
CREATE USER : 데이터베이스 유저 생성 권한
CREATE SESSION : 데이터베이스 접속 권한
CREATE TABLE : 테이블 생성 권한
CREATE VIEW : 뷰 생성 권한
CREATE SEQUENCE : 시퀀스 생성 권한

ALTER ANY TABLE : 어떠한 테이블도 수정할 수 있는 권한
INSERT ANY TABLE : 어떠한 테이블에도 데이터를 삽입하는 권한
그 외 ) SELECT ANY ,,, UPDATE ANY ,,,

SELECT ON table이름 TO user이름 : 특정테이블만 조회할 수 있는 권한
그 외 ) INSERT ON ,,, UPDATE ON ,,,

-- 관리자에 준하는 거의 모든 권한 다 주기
RESOURCE, CONNECT, DBA TO 유저이름
*/

GRANT CREATE SESSION TO user1;  -- 데이터베이스에 접속할 수 있는 권한주기

GRANT CONNECT, RESOURCE, DBA TO user1; -- user1에게 모든 권한 다 주기


-- 디벨로퍼에서 user1으로 접속등록하기 - 저장
CREATE TABLE t_test (
    bno NUMBER(3)
);  -- 테이블 생성 가능
CREATE SEQUENCE t_test_seq; -- 시퀀스 생성 가능
INSERT INTO t_test VALUES (t_test_seq.NEXTVAL);

-- system 계정으로 들어가서
REVOKE CONNECT, RESOURCE, DBA FROM user1; -- 권한 회수하기

-- ------------
-- 사용자 계정 삭제
-- DROP USER 유저이름 CASCADE; : 계정에 달려있는 모든 데이터까지 다 삭제하기
-- ( CASCADE 없을 시 )-> 테이블, 시퀀스 존재하면 삭제안됨

/*
테이블 스페이스는 데이터베이스 객체 내 실제 데이터가 저장되는 공간입니다.
테이블 스페이스를 생성하면 지정된 경로에 실제 파일로 정의한 용량만큼의 파일이 (물리적)생성되고, 데이터가 물리적으로 저장됩니다.
당연히 테이블 스페이스의 용량을 초과한다면 프로그램이 비정상적으로 동작합니다.
*/

-- 테이블스페이스 조회
SELECT * FROM dba_tablespaces;

-- USERS 테이블 스페이스를 기본 사용 공간으로 지정해야한다. (기본값:0) 
-- 용량 지정해줘야한다. -> 그래야지 INSERT 가능 (users가 자동지정되나...?모르겠음)
ALTER USER user1 DEFAULT TABLESPACE users   -- users를 기본 테이블스페이스로 설정하겠다
QUOTA UNLIMITED ON users;   -- 용량을 무제한으로 주기.

-- 테이블스페이스 생성하기 (SQL 몰라도) (권한있는지 미리확인!!)
-- 디벨로퍼 - 보기 - DBA - (왼쪽하단 DBA창 생긴데에서) 접속 - 계정선택 - 비밀번호입력 -
-- 계정 더블클릭 - 저장영역 - 테이블스페이스 우클릭 - 새로만들기
-- 맨위 이름 맘대로(선생님:USER_TABLESPACE), 중간쯤 이름 "USER_TABLESPACE.DBF"  (: 실제파일이름. 쌍따옴표까지쓰기)
-- 디렉토리 : (윈도우기준 기본지정 : c드라이브 - oraclexe - app - oracle - oradata - xe 복사해서 디렉토리에 붙여넣기)
-- 파일크기 : (500 M)
-- 재사용 : 크기가 꽉 찼을때 재사용할지
-- 자동확장설정 (체크) - 다음크기 500 M 

-- SQL문 알아보기 : 디벨로퍼에서 테이블스페이스 가서 SQL 탭

-- 내가만든 테이블스페이스 써라
ALTER USER user1 DEFAULT TABLESPACE USER_TABLESPACE
QUOTA UNLIMITED ON users;

-- 테이블 스페이스 내의 객체를 전체 삭제하는법 (SQL문)
DROP TABLESPACE USER_TABLESPACE INCLUDING CONTENTS;
-- (디벨로퍼에서는 우클릭 삭제 해도 된다.)

-- 물리적 파일까지 한번에 삭제하는 법
DROP TABLESPACE USER_TABLESPACE INCLUDING CONTENTS AND DATAFILES;



-- 권한 : 나중에 부장이 될때를 위한 권한공부 ^^ 그전에는 권한을 줄 권한이 없을것...

