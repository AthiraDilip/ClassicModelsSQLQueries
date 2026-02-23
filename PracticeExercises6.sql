-- Questions Source - https://github.com/Mikegr1990/ClassicModels-SQL-Solutions/blob/main/General-Queries/
-- General Queries
SHOW DATABASES;
SELECT DATABASE();
USE classicmodels;
SHOW TABLES;

-- 1. Who is at the top of the organization (i.e.,  reports to no one).
SELECT
	CONCAT (firstName, ' ', lastName),
    employeeNumber,
    jobTitle,
    reportsTo
FROM employees
WHERE reportsTo IS NULL;


-- 2. Who reports to William Patterson?
SELECT *
FROM employees
WHERE reportsTo = (SELECT employeeNumber FROM employees WHERE firstName = 'William' AND lastName = 'Patterson');

