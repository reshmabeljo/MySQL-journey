CREATE schema Employee;

USE Employee;

#Table Creation
CREATE  TABLE departments
(
department_id  INT  ,
department_name VARCHAR(100)
);

CREATE TABLE location
(
location_Id INT ,
location_Name VARCHAR(30)

);

CREATE TABLE employees
(
employee_id int ,
employee_name varchar(50),
gender enum('M','F'),
age int,
hire_date date,
designation varchar(100),
department_id int,
location_id  int,
salary decimal(10,2)
);

#Table Alteration (ALTER):


alter table employees add email varchar(50);

alter table employees modify  designation varchar(150);

alter table employees  drop column age;

alter table employees rename column hire_date to date_of_joining;

rename table departments to Departments_Info;
 
rename  table location to Locations;

truncate table employees;

drop table employees;
drop schema employee;

# Constraints

CREATE schema Employee;

use Employee;

create  table departments
(
department_id  INT primary key ,
department_name Varchar(100) not null unique
);

create table location
(
location_Id int  auto_increment primary key,
location_Name varchar(30) not null unique

);

create table employees
(
employee_id int primary key,
employee_name varchar(50) not null,
gender char(1) check(gender in('M','F')),
age int check(age>=18),
hire_date date default(current_date()),
designation varchar(100),
department_id int ,
location_id  int,
salary decimal(10,2),
foreign key(department_id) references departments(department_id),
foreign key(location_id) references location(location_id)

);
