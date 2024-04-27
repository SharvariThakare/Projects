CREATE DATABASE employee;
/*3.Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, 
and make a list of employees and details of their department.*/
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM emp_record_table
ORDER BY DEPT;
/*4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is:
•	less than two
•	greater than four
•	between two and four
*/
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING >4;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4;
/*5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table 
and then give the resultant column alias as NAME.*/
SELECT concat_ws(' ',First_name, Last_name) as Name FROM employee.emp_record_table WHERE Dept="FINANCE";
/*6.Write a query to list only those employees who have someone reporting to them.
 Also, show the number of reporters (including the President).*/
 SELECT @@sql_mode;
SELECT m.EMP_ID, m.FIRST_NAME, m.LAST_NAME, m.ROLE, m.DEPT, count(e.EMP_ID) AS emp_recording FROM emp_record_table m
INNER JOIN emp_record_table e
ON m.EMP_ID = e.MANAGER_ID
AND e.EMP_ID != e.MANAGER_ID
WHERE m.Role in("MANAGER","PRESIDENT","CEO")
GROUP BY m.EMP_ID
ORDER BY m.EMP_ID;
/* 7. Write a query to list down all the employees from the healthcare and finance departmentsomain using union.
 Take data from the employee record table.*/
SELECT m.Emp_id, m.First_name, m.Last_name, m.Dept FROM emp_record_table m
 WHERE m.Dept IN ("HEALTHCARE","FINANCE")
 UNION
SELECT m.Emp_id, m.First_name, m.Last_name, m.Dept FROM emp_record_table m
 WHERE m.Dept IN ("HEALTHCARE","FINANCE")
 ORDER BY Dept;
  /* 8. Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept.
 Also include the respective employee rating along with the max emp rating for the department.
First variant:*/
SELECT Dept, emp_id, First_name, Last_name, Role, emp_rating, 
       MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS MAX_RATING 
FROM   emp_record_table 
ORDER BY DEPT, EMP_RATING DESC;
/*9. Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.*/
SELECT ROLE, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY ROLE;
/*10.Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.*/
SELECT emp_id, first_name, last_name, role, Dept, Exp, rank() over (order by Exp) emp_experience_rank, 
dense_rank() over (order by Exp) emp_experience_denserank from emp_record_table;
/*11. Write a query to create a view that displays employees in various countries whose salary is more than six thousand.
 Take data from the employee record table.*/
CREATE VIEW Employee_view AS 
SELECT Emp_id, Country, Salary from emp_record_table where salary > 6000;
/*12. Write a nested query to find employees with experience of more than ten years.
 Take data from the employee record table.*/
SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT, EXP 
FROM emp_record_table
WHERE EXP > 10;
 /*13. Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years.
 Take data from the employee record table.*/
 CREATE PROCEDURE get_experience()
 SELECT * FROM emp_record_table WHERE Exp > 3;
 
 /*14. Write a query using stored functions in the project table to check whether the job profile assigned to each employee in 
 the data science team matches the organization’s set standard. The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.*/
 DELIMITER $$
DROP FUNCTION IF EXISTS employee.get_job_profile;
CREATE FUNCTION employee.get_job_profile(Exp INT)
RETURNS VARCHAR(2000) DETERMINISTIC
BEGIN
    DECLARE job_profile VARCHAR(2000);
    IF Exp <= 2 THEN
        SET job_profile = 'JUNIOR DATA SCIENTIST';
    ELSEIF Exp <= 5 THEN
        SET job_profile = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF Exp <= 10 THEN
        SET job_profile = 'SENIOR DATA SCIENTIST';
    ELSEIF Exp <= 12 THEN
        SET job_profile = 'LEAD DATA SCIENTIST';
    ELSEIF Exp <= 16 THEN
        SET job_profile = 'MANAGER';
    END IF;
    RETURN job_profile;
END $$
DELIMITER ;
SELECT First_name,Last_name,Exp,Role, get_job_profile(Exp) AS Employee_profile
FROM employee.emp_record_table order by Exp;
 /*15. Create an index to improve the cost and performance of the query to find 
the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan. */
CREATE INDEX index_emp ON emp_record_table(FIRST_NAME);
SELECT * FROM emp_record_table WHERE First_name = 'Eric';
/*16. Write a query to calculate the bonus for all the employees,
alter based on their ratings and salaries (Use the formula: 5% of salary * employee rating).*/
SELECT Emp_id, First_name, Last_name, Role, Salary, Emp_rating, 0.05*Salary*Emp_rating as BONUS
FROM emp_record_table 
ORDER BY BONUS;
/*17. Write a query to calculate the average salary distribution based on the continent and country.
 Take data from the employee record table.*/
SELECT country, continent, avg(Salary) over ( partition by country) AVG_Salary_Distr_Country,
avg(Salary) over ( partition by Continent) AVG_Salary_Distr_Continent from emp_record_table;

 
