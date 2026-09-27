use employee;
select * from employees;
select * from departments;
select * from location;

-- Distinct Values:
select distinct salary from employees;

-- Alias (AS):
select age as Employee_Age,salary as Employee_Salary  from employees;

-- Where Clause & Operators:

select employee_id,employee_name from employees where salary>50000 and  hire_date<'2016-01-01';

select * from employees where designation is null;

update employees set designation='Data  Scientist' where designation is null;


-- ORDER BY: 
select * from employees order by department_id  ASC,salary DESC;

--  LIMIT:
select * from employees where year(hire_date)=2018 limit 5;

-- Aggregate Functions:
select sum(salary) from employees where department_id=7;

select min(age) from employees;

-- GROUP BY:

select location_id,max(salary) from employees group by location_id;

select designation,avg(salary) from employees where designation like'%Analyst%'  group by designation;

-- HAVING:
select department_id,count(*) as emp_count from employees group by department_id having emp_count<3;

select location_id,count(*) as female_emp_count, AVG(age) AS average_age from employees where gender='F' group by location_id
having avg(age)<30;

--  Inner Join:
select employee_name,designation,department_name from employees emp
inner join departments dep on dep.department_id=emp.department_id;

--  Left Join:
select dep.department_id,dep.department_name,count(employee_id) from departments dep 
left join employees emp on emp.department_id=dep.department_id
group by dep.department_id,dep.department_name;

--  Right Join:
select employee_name,location from employees emp right join location loc on loc.location_id=emp.location_id

