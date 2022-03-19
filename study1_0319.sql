---------------------------------
--실습예제 03/18
---------------------------------
--부서별 최대급여를 받는 사원의 사원명, 부서명, 급여를 출력. 
select
    e.emp_name 사원명
    ,d.dept_title 부서명
    ,to_char(e.salary,'fml999,999,999') 급여
from
    employee e
        join department d
            on e.dept_code = d.dept_id
where
    (dept_code, salary) in (select dept_code, max(salary) from employee group by dept_code)
order by 3 desc;


--(심화1) 최소급여를 받는 사원도 출력.
select
    e.emp_name 사원명
    ,d.dept_title 부서명
    ,to_char(e.salary,'fml999,999,999') 급여
from
    employee e
        join department d
            on e.dept_code = d.dept_id
where
    (dept_code, salary) in (select dept_code, max(salary) from employee group by dept_code)
    or
    (dept_code, salary) in (select dept_code, min(salary) from employee group by dept_code)
order by 3;


--(심화2) 인턴사원도 포함시키기
select
    e.emp_name 사원명
    ,d.dept_title 부서명
    ,to_char(e.salary,'fml999,999,999') 급여
from
    employee e
        left join department d
            on e.dept_code = d.dept_id
where
    (nvl(dept_code,'인턴'), salary) in (select nvl(dept_code,'인턴'), max(salary) from employee group by dept_code)
    or
    (nvl(dept_code,'인턴'), salary) in (select nvl(dept_code,'인턴'), min(salary) from employee group by dept_code)
order by 3;

