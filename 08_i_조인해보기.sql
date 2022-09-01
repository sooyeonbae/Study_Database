-- 엑셀파일 참고


-- 조인 : 테이블과 테이블을 합쳐서 한번의 결과를 얻어내기. 두 개의 테이블을 서로 연관해서 조회하는 것.
-- 오라클조인구문 , ANSI 조인구문
-- 종류 ) inner join, outer join(left, right, full outer), cross join, self join . . .
-- DMBS마다 조인문법이 다르다. -> ansi (미국산업표준기구에서 통일시킴.) -> ANSI가 대세!

/*
# 조인이란?
- 서로 다른 테이블간에 설정된 관계가 결합하여
1개 이상의 테이블에서 데이터를 조회하기 위해서 사용합니다.

- (오라클 조인 문법)
    SELECT 컬럼리스트 FROM 조인대상이 되는 테이블 (1개이상)
    WHERE 조인조건
- (ANSI 조인)




*/

-- 1. 내부조인 (inner join) : 두 테이블 모두에서 일치하는 값을 가진 행만 반환합니다.
--                        모든데이터 가져오려면 외부조인. (정보없는거 null로 채워짐)



-- employees 테이블의 부서 id와 일치하는 departments 테이블의 부서 id를 찾아서
-- SELECT 이하에 있는 컬럼들을 출력하는 쿼리문.

--(오라클의 조인문법)
SELECT
    e.first_name, e.last_name, e.hire_date, e.salary, e.job_id, 
    e.department_id, -- employees & departments 테이블에 있음
    d.department_name -- departments 테이블에 있음.
FROM employees e, departments d -- e,d : 별칭붙여주기 -> 컬럼들에 다 별칭붙여주기
WHERE e.department_id = d.department_id;    -- 조건 : emp~의 dp_id가 dp~의 dp_id가 같다면.

--(ANSI 표준 조인문법)
SELECT
    e.first_name, e.last_name, e.hire_date, e.salary, e.job_id, 
    e.department_id,
    d.department_name
FROM employees e INNER JOIN departments d -- INNER JOIN
ON e.department_id = d.department_id;    -- 조건 : ON 뒤에.

/*
각각의 테이블에 독립적으로 존재하는 컬럼의 경우에는 별칭을 생략해도 무방합니다.
그러나, 해석의 명확성을 위해 테이블 이름을 작성하셔서 소속을 표현해주는 것이 바람직합니다.
테이블 이름이 너무 길 시에는 alias를 작성하여 칭합니다.
두 테이블 모두 가지고 있는 컬럼의 경우 반드시 명시해 주셔야 합니다.
*/

-- 3개의 테이블을 이용한 내부 조인 (INNER JOIN)
SELECT
    e.first_name, e.last_name, e.department_id, d.department_name,
    j.job_title
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id
AND e.job_id = j.job_id; -- 실제로 활동하는 직무만 가져오게된다.

-- 오라클문법으로 여러개 테이블 내부조인 (조인조건과 일반조건 모두 WHERE 이라 순서로 판단해야한다. 마지막에 일반조건 몰아쓰기, 일반조건부터 해석된다.)
SELECT 
    e.first_name, e.last_name, e.department_id, 
    d.department_name, e.job_id,
    j.job_title, loc.city 
FROM 
    employees e,
    departments d,
    jobs j,
    locations location_id
WHERE e.department_id = d.department_id -- join조건
AND e.job_id = j.job_id             -- join조건 (3,4)
AND d.location_id = loc.location_id      -- join조건 (2)
AND loc.state_province = 'California';      -- join조건 아니고 일반조건 (맨마지막에 붙여야한다.) (1)
-- 해석순서)  (1) loc테이블의 province='California'조건에 맞는 값을 대상으로
-- (2) location_id값과 같은 값을 가지는 데이터를 departments에서 찾아서 조인 실행
-- (3) 위의 결과와 동일한 department_id를 가진 employees 테이블의 데이터를 찾아 조인
-- (4) 위의 결과와 jobs 테이블을 비교하여 조인하고 최종 결과를 출력.



-- ----------------------
-- 2. 외부조인 (outer join) : 상호 테이블간에 일치되는 값으로 연결되는 내부조인과는 다르게
--          어느 한 테이블에 공통값이 없더라도 해당 row들이 조회결과에 모두 포함되는 조인을 말합니다.

SELECT
    e.first_name, e.last_name,
    e.department_id, 
    d.department_name 
FROM employees e, departments d, locations loc
WHERE e.department_id = d.department_id(+)
AND d.location_id = loc.location_id;    -- (+) 붙여서 외부조인. null값인것도 가져오게된다.
/*
employees 테이블에는 존재하고, departments 테이블에는 존재하지 않아도
 (+)가 붙지 않은 테이블을 기준으로 하여 departments 테이블이 조인에 참여하라는 의미를 부여하기위해 기호를 붙입니다.
 외부조인을 사용했더라도, 이후에 내부조인을 사용하면 내부조인을 우선적으로 인식합니다.
*/ 
-- 내부조인이 먼저 해석된다. 내부조인의 조건에 충족되지 않은 데이터는 외부조인에 못붙어나옴.

SELECT
    e.employee_id, e.first_name, e.department_id,
    j.start_date, j.end_date, j.job_id
FROM employees e, job_history j
WHERE e.employee_id = j.employee_id(+)
AND j.department_id = 80(+);
-- 외부조인 진행시 모든 조건에 (+)을 붙여야 하며
-- 일반 조건에도 (+)를 붙이지 않으면 데이터가 누락되는 현상이 발생된다.





--LEFT OUTER JOIN
ORACLE sql :
--RIGHT OUTER JOIN
--FULL OUTER JOIN : left와 right가 같이 나온다.
-- 오라클은 없다. ANSI : SELECT * FROM into FULL OUTER JOIN auth ON info.auth_id=auth.auth_id;
                                                                --순서 바뀌어도됨
                                -- JOIN 만 써도 INNER JOIN 으로 인식
                                -- LEFT JOIN RIGHT JOIN FULL JOIN (OUTER 없어도 다 - outer join으로 인식)

-- CROSS JOIN : 조인조건이 없고 모든 형태의 조인을 다 붙여버린다.
--의미가없는 데이터가 조회되고 그 양이 너무 방대하기때문에 피해야 하는 조인

-- SELF JOIN : 자기자신을 조인 (내 테이블을 한번 더 결합)
-- 똑같은
