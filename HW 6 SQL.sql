CREATE TABLE departments (
  dept_no VARCHAR(4) NOT NULL,
  dept_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (dept_no),
  UNIQUE (dept_name)
);

select * from departments;

INSERT INTO departments (dept_no, dept_name)
VALUES ('d001','Marketing'),
('d002','Finance'),
('d003','Human Resources'),
('d004','Production'),
('d005','Development'),
('d006','Quality Management'),
('d007','Sales'),
('d008','Research'),
('d009','Customer Service');

CREATE TABLE employees (
  emp_no INT NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

Select * from dept_manager

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

Select * from dept_emp

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

Select * from titles

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);
Select * from salaries



-- Select all the employees who were born between January 1, 1952 and December 31, 1955 and their titles and title date ranges
-- Order the results by emp_no

WITH retiring AS (SELECT * FROM employees 
WHERE birth_date  BETWEEN '1952-01-01' AND '1955-12-31')
SELECT retiring.emp_no, 
		retiring.first_name,
		retiring.last_name,
		retiring.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		FROM retiring JOIN titles 
		ON retiring.emp_no=titles.emp_no
		ORDER BY emp_no ;
		
-- Select only the current title for each employee
WITH employee_data AS (
WITH retiring AS (SELECT * FROM employees 
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31')
SELECT retiring.emp_no, 
		retiring.first_name,
		retiring.last_name,
		retiring.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		FROM retiring JOIN titles 
		ON retiring.emp_no=titles.emp_no
		ORDER BY emp_no),
		
updated_list AS (
SELECT emp_no, MAX(from_date) AS current_titles FROM titles GROUP BY emp_no)

SELECT employee_data.emp_no, employee_data.first_name, employee_data.last_name, employee_data.title AS current_titles FROM employee_data JOIN updated_list ON ((employee_data.emp_no=updated_list.emp_no) and (employee_data.from_date=updated_list.current_titles));


-- Count the total number of employees about to retire by their current job title

WITH current_retire AS (
WITH employee_data AS (
WITH retiring AS (SELECT * FROM employees 
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	
SELECT retiring.emp_no, 
		retiring.first_name,
		retiring.last_name,
		retiring.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		FROM retiring JOIN titles 
		ON retiring.emp_no=titles.emp_no
		ORDER BY emp_no),
		
updated_list AS (
SELECT emp_no, MAX(from_date) AS current_titles FROM titles GROUP BY emp_no)

SELECT employee_data.emp_no, employee_data.first_name, employee_data.last_name, employee_data.title AS current_titles FROM employee_data JOIN updated_list ON ((employee_data.emp_no=updated_list.emp_no) AND (employee_data.from_date=updated_list.current_titles)))

SELECT current_titles, COUNT (*) AS emp_count FROM current_retire GROUP BY current_titles;

-- Count the total number of employees per department
WITH department_count AS(
SELECT dept_no, COUNT(emp_no) AS emp_count FROM dept_emp GROUP BY dept_no )
SELECT dept_name, department_count.emp_count FROM departments JOIN department_count ON (departments.dept_no=department_count.dept_no);

-- Bonus: Find the highest salary per department and department manager

 With newest AS(
 select df1.dept_no, df2.emp_no, df2.salary
from dept_manager as df1
join salaries as df2 on df1.emp_no = df2.emp_no)


select f.dept_no, f.emp_no, f.salary
from (
   select dept_no, max(salary) as maxsalary
   from newest group by dept_no
) as x inner join newest as f on f.dept_no = x.dept_no and f.salary = x.maxsalary;
					   

