/*
MySQL : autocommit이 디폴트... (insert,update,delete . . .할때마다 자동으로 커밋)
ORACLE : 따로 설정해야한다. (확인법 : SHOW AUTOCOMMIT;)
                       ( ON : SET AUTOCOMMIT ON; )
                        (OFF : SET AUTOCOMMIT OFF; )

*/

select * FROM emps; -- 확인

INSERT INTO emps 
    (employee_id, last_name, email, hire_date, job_id)
VALUES (300, 'Kim', 'abc@naver.com', sysdate, 1800);

-- ROLLBACK : 보류중인 모든 데이터 변경사항을 취소(폐기), 직전 커밋 단계로 회귀(돌아가기) 및 트랜잭션 종료.
ROLLBACK;

-- SAVEPOINT : 롤백할 포인트를 직접 이름을 붙여서 지정.
-- ANSI 표준 문법이 아니기 떄문에 그렇게 권장하지는 않음.
SAVEPOINT insert_kim;

INSERT INTO emps 
    (employee_id, last_name, email, hire_date, job_id)
VALUES (301, 'Park', 'ccc@naver.com', sysdate, 1800);

ROLLBACK; -- kim, park 둘다사라짐

ROLLBACK TO SAVEPOINT insert_kim; -- SAVEPOINT insert_kim으로 롤백


-- COMMIT : 보류중인 모든 데이터 변경사항을 영구적으로 적용하면서 트랜잭션을 종료.
-- 커밋한 이후에는 어떤 방법을 사용하더라도 되돌릴 수 없습니다. 
-- (테이블, 계정같은거(DDL)는 자동 저장. 롤백 커밋 없음)
COMMIT;