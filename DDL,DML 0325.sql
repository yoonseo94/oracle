-----------------------------------------------------
-- DML 실습문제 03/25
-----------------------------------------------------

-- 1. 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오.
-- 번호, 유형이름
--------------
-- 01, 전공필수
-- 02, 전공선택
-- 03, 교양필수
-- 04, 교양선택
-- 05. 논문지도

create table tb_class_type (
    class_type_no char(2) not null,
    class_type_name varchar(20) not null
);
insert into tb_class_type values ('01','전공필수');
insert into tb_class_type values ('02','전공선택');
insert into tb_class_type values ('03','교양필수');
insert into tb_class_type values ('04','교양선택');
insert into tb_class_type values ('05','논문지도');

select * from tb_class_type;


-- 2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 만들고자 한다.
--    아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (서브쿼리를 이용하시오)
-- 테이블이름 : TB_학생일반정보
-- 컬럼: 학번,학생이름,주소
create table tb_학생일반정보 
as
select
    student_no 학번
    , student_name 학생이름
    , student_address 주소
from 
    tb_student;
    
select * from tb_학생일반정보;


-- 3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블을 만들고자 한다.
-- 아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (힌트 : 방법은 다양함, 소신껏 작성하시오)
-- 테이블이름 : TB_국어국문학과
-- 컬럼 : 학번, 학생이름, 출생년도 <= 네자리 년도로 표기, 교수이름
create table tb_국어국문학과
as
select
    s.student_no 학번
    , s.student_name 학생이름
    , '19' || substr(s.student_ssn, 1, 2) 출생년도
    , p.professor_name 교수이름
from
    tb_student s
        left join tb_professor p
            on s.coach_professor_no = p.professor_no
        join tb_department d
            on(s.department_no = d.department_no)
where d.department_name = '국어국문학과';

select * from tb_국어국문학과;

--4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용한 SQL 문을 작성하시오. (단,
--   반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다)

update 
    tb_department
set 
    capacity = round(capacity * 0.1);

-- 5. 학번 A413042 인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21 "로 변경되었다고한다. 
--    주소지를 정정하기 위해 사용한 SQL 문을 작성하시오.

update
    tb_student
set
    student_address = '서울시 종로구 숭인동 181-21'
where
    student_no = 'A413042';

select * from tb_student where student_no = 'A413042';
commit;

-- 6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 결정하였다. 
--    이 내용을 반영할 적절한 SQL 문장을 작성하시오.
--    (예. 830530-2124663 ==> 830530 )

update 
    tb_student
set
    student_ssn = substr(student_ssn, 1, 6);

select * from tb_student;
commit;

-- 7. 의학과 김명훈 학생은 2005 년 1 학기에 자신이 수강한 '피부생리학' 점수가
--    잘못되었다는 것을 발견하고는 정정을 요청하였다. 담당 교수의 확인 받은 결과 해당
--    과목의 학점을 3.5 로 변경키로 결정되었다. 적절한 SQL 문을 작성하시오.
update
    tb_grade
set 
    point = 3.5
where 
    student_no = (
                    select student_no from tb_student where student_name = '김명훈'
                    and department_no = 
                    (select department_no from tb_department where department_name = '의학과')
                 )
    and class_no = (select class_no from tb_class where class_name = '피부생리학')
    and term_no = '200501';



select * from tb_grade 
where 
    student_no in (select student_no from tb_student where student_name = '김명훈')
    and
    class_no in (select class_no from tb_class where class_name = '피부생리학');



-- 8. 성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목을 제거하시오


delete 
from 
    tb_grade
where 
    student_no in (select student_no from tb_student where absence_yn = 'Y');


select * from tb_grade
where 
    student_no in(select student_no from tb_student where absence_yn = 'Y');
    
    
-----------------------------------------------------
-- DDL 실습문제 03/25
-----------------------------------------------------    
--1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
-- 테이블 이름 : TB_CATEGORY
-- 컬럼 : NAME, VARCHAR2(10) // USE_YN, CHAR(1), 기본값은 Y 가 들어가도록

create table tb_category (
    name varchar(10),
    use_yn char(1) default 'Y'
);

select * from tb_category;

commit;


-- 2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
-- 테이블이름 : TB_CLASS_TYPE
-- 컬럼 : NO, VARCHAR2(5), PRIMARY KEY // NAME , VARCHAR2(10) 

-- drop table tb_class_type;
create table tb_class_type (
    no varchar(5),
    name varchar(10),
    
    constraint pk_tb_class_type primary key (no)
);

desc tb_class_type;
-- 제약조건확인
select A.owner, 
    A.table_name, 
    B.column_name,
    constraint_name,
    A.constraint_type,
    A.search_condition
from user_constraints A join user_cons_columns B
    using(constraint_name)
where A.table_name = 'TB_CLASS_TYPE';
--3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY 를 생성하시오.
--(KEY 이름을 생성하지 않아도 무방함. 만일 KEY 이를 지정하고자 한다면 이름은 본인이
--알아서 적당한 이름을 사용한다.)

alter table
    tb_category
add
    constraint pk_tb_catagory primary key(name);
-- 제약조건확인
select A.owner, 
    A.table_name, 
    B.column_name,
    constraint_name,
    A.constraint_type,
    A.search_condition
from user_constraints A join user_cons_columns B
    using(constraint_name)
where A.table_name = 'TB_CATEGORY';


-- 4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오

alter table
    tb_class_type
modify
    name varchar2(10) not null;
    
desc tb_class_type;

-- 5. 두 테이블에서 컬럼명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 컬럼명이
--    NAME 인 것은 마찬가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.

desc tb_category;
desc tb_class_type;

alter table tb_class_type
modify 
--    name varchar2(20)
    no varchar2(10);

alter table tb_category
modify
    name varchar2(20);

--6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외한 테이블 이름이 앞에
--붙은 형태로 변경핚다.
--(ex. CATEGORY_NAME)

alter table 
    tb_category
rename
    column name to category_name;

alter table
    tb_class_type
rename
    column no to class_type_no;
    
alter table
    tb_class_type
rename
    column name to class_type_name;   
    
select * from tb_category;
select * from tb_class_type;

-- 7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오.
--    Primary Key 의 이름은 ‚PK_ + 컬럼이름‛으로 지정하시오. (ex. PK_CATEGORY_NAME )
select
    constraint_name,
    uc.table_name,
    ucc.column_name,
    uc.constraint_type,
    uc.search_condition
from
    user_constraints uc join user_cons_columns ucc
        using(constraint_name)
where
    uc.table_name = 'TB_CLASS_TYPE';

alter table
    tb_category
rename
    constraint PK_TB_CATAGORY to pk_category_name;

alter table
    tb_class_type
rename
    constraint PK_TB_CLASS_TYPE to pk_class_type_no;
    
    
-- 8. 다음과 같은 INSERT 문을 수행핚다.
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT; 

-- 9.TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모
-- 값으로 참조하도록 FOREIGN KEY 를 지정하시오. 이 때 KEY 이름은
-- FK_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY )
alter table 
    tb_department
add 
    constraint fk_department_category foreign key (category) references tb_category(category_name);

-- 10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW 를 만들고자 한다.
-- 아래 내용을 참고하여 적절한 SQL 문을 작성하시오
-- 뷰 이름 : VW_학생일반정보
-- 컬럼 : 학번, 학생이름, 주소
grant create view to chun;
create view vw_학생일반정보
as
select 
    student_no, student_name, student_address 
from 
    tb_student;

select * from vw_학생일반정보;

-- 11. 춘 기술대학교는 1 년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행한다.
-- 이를 위해 사용할 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 만드시오.
-- 이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 (단, 이 VIEW 는 단순 SELECT
-- 만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)
-- 뷰 이름 : VW_지도면담
-- 컬럼 : 학생이름, 학과이름, 지도교수이름

create view vw_지도면담
as
select
    s.student_name 학생이름
    , (select department_name from tb_department where s.department_no = department_no) 학과이름
    , (select professor_name from tb_professor where s.coach_professor_no = professor_no) 지도교수이름
from
    tb_student s;
       
select * from vw_지도면담;

-- 12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW 를 작성해 보자.
-- 뷰 이름 : VW_학과별학생수
-- 컬럼 : DEPARTMENT_NAME, STUDENT_COUNT
create view VW_학과별학생수
as
select 
    department_name, 
    count(*) student_count
from 
    tb_student ts
        join tb_department td
            on (ts.department_no = td.department_no)
group by 
    department_name;

select * from VW_학과별학생수;


-- 13. 위에서 생성한 학생일반정보 View 를 통해서 학번이 A213046 인 학생의 이름을 본인
-- 이름으로 변경하는 SQL 문을 작성하시오.

select * from vw_학생일반정보 where student_no = 'A213046';

update 
    vw_학생일반정보
set
    student_name = '최윤서'
where 
    student_no = 'A213046';
    
-- 14. 13 번에서와 같이 VIEW 를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW 를
-- 어떻게 생성해야 하는지 작성하시오.

create or replace view vw_학생일반정보
as
select 
    department_name, 
    count(*) student_count
from 
    tb_student ts
        join tb_department td
            on (ts.department_no = td.department_no)
group by 
    department_name
    
with read only;    
