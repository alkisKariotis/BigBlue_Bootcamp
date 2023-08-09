--HR DATABASE IN PG ADMIN 

--1. Sort the employees by their last name, their salary and their hire date

select last_name, salary, hire_date
from employees
order by last_name, salary, hire_date;

--2. How many employees are there? How many departments and job specialties? (give a name to the new columns)

select count(distinct employee_id) as number_of_employees,  count(distinct job_id) as job_specialties,  count(distinct department_id) as number_of_departments
from employees;

--3a. What is the average salary of all employees? How much is the company paying for salaries in total?

select avg(salary) as average_salary, sum(salary) as company_total_payments
from employees;

--3b. Who is getting the highest and who the lowest salary?

select first_name, last_name, salary
from employees
where salary = (select max(salary) from employees) or salary = (select min(salary) from employees);

--4a. How many employees are working in each department? find the five departments with the most of them.

select  department_id, count(employee_id) as number_of_employees
from employees
group by department_id
order by count(employee_id) DESC
limit 5;

--4b. Find the five specialties with the most employees, too.

select  job_id, count(employee_id) as number_of_employees
from employees
group by job_id
order by count(employee_id) DESC
limit 5;

--4c. Find how many employees were hired per department from 1990 to the end of 1995.

select department_id, count(employee_id) as number_of_employees
from employees
where hire_date between '1990-01-01' and '1995-12-30'
group by department_id;

--5. How many employees does each manager supervise and what are the total salaries they manage?  We are interested only for managers with at least 2 supervisors.

select manager_id, count(employee_id) as number_of_employees, sum(salary)
from employees
group by manager_id
having count(employee_id) > 2;

--6a.what is the lowest and highest salary for departments which have more than two employees?

select department_id, count(employee_id) as number_of_employees, max(salary) as max_department_salary, min(salary) as min_department_salary
from employees
group by department_id
having count(employee_id) > 2;


--6b. What is each specialty's average salary with more than one employees?

select job_id, count(employee_id), avg(salary)
from employees
group by job_id
having count(employee_id) > 1;

--6c. What about each department's average salary and total budget? sort them by average

select department_id, avg(salary) as average_salary_of_department, sum(salary) as total_budget_of_department
from employees
group by department_id
order by avg(salary) DESC;

--6d. filter the last question for departments with more than two employees and average salary higher than 6000.

select department_id, count(employee_id), avg(salary) as average_salary_of_department, sum(salary) as total_budget_of_department
from employees
group by department_id
having count(employee_id) > 2 and avg(salary) > 6000
order by avg(salary) DESC;

--7 bonus. print the departments' names alongside the rest of the info.

select *
from employees, departments;

--COULD NOT FIND ANOTHER WAY INSTEAD OF JOIN

select employees.*, departments.department_name
from employees inner join departments
on employees.department_id = departments.department_id;