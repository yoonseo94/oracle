--@실습문제 : INNER JOIN & OUTER JOIN 03/17
--1. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시

select
        s.student_no 학번
        , s.student_name 학생명
        , nvl(p.professor_name,'없음') 담당교수명
from    
        tb_student s 
            left join tb_professor p
                on s.coach_professor_no = p.professor_no;


--2. 학과별 교수명과 인원수를 모두 표시하세요.
select
        d.department_name 학과
        , p.professor_name 교수명
        , d.capacity 인원수
from
        tb_department d
            left join tb_professor p
                using(department_no)
order by 1;


-- 3. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- (동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)
select
        s.student_no 학번
        , s.student_name 학생명
        , round(avg(g.point) ,2) 평균학점
from 
        tb_student s
            join tb_grade g
                on s.student_no = g.student_no
where 
        s.student_name like '%람'
group by 
        s.student_no, s.student_name;


--4. 학생별 다음정보를 구하라.
/*
--------------------------------------------
학생명  학기     과목명    학점
-------------------------------------------
감현제    200401    전기생리학     4.5
            .
            .
--------------------------------------------

*/

select
        s.student_name 학생명
        , g.term_no 학기
        , c.class_name 과목명
        , g.point 학점
from
        tb_student s
            left join tb_grade g
                using(student_no)
            left join tb_class c
                using(class_no)
order by 1,2,3 ;