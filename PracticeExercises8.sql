-- https://github.com/Mikegr1990/ClassicModels-SQL-Solutions/blob/main/Regular-Expressions/query_1.sql
-- Regular-Expressions
-- 1. Find products containing the name 'Ford'.
SELECT * FROM products
WHERE productName LIKE '%Ford%';

-- 2. List products ending in 'ship'.
SELECT * FROM products
WHERE productName LIKE '%ship';

-- 3. Report the number of customers in Denmark, Norway, and Sweden
SELECT
	country,
    COUNT(*) AS customerCount
FROM customers
WHERE country IN ('Denmark', 'Norway', 'Sweden')
GROUP BY country;

-- 4. What are the products with a product code in the range S700_1000 to S700_1499?
SELECT *
FROM products
WHERE RIGHT(productCode, 4) BETWEEN 1000 AND 1499;

-- 5. Which customers have a digit in their name?
SELECT *
FROM customers
WHERE customerName REGEXP '[0-9]';

-- 6. List the names of employees called Dianne or Diane.
SELECT *
FROM employees
WHERE firstName = 'Dianne' OR firstName ='Diane';

-- 7. List the products containing ship or boat in their product name.
-- My solution
SELECT *
FROM products
WHERE productName LIKE '%ship%' OR '%boat%';

-- Solution from web
SELECT *
FROM products
WHERE productName REGEXP 'ship'|'boat';

-- 8. List the products with a product code beginning with S700.
SELECT *
FROM products
WHERE productCode REGEXP'^S700';

-- 9. List the names of employees called Larry or Barry.
-- My solution
SELECT *
FROM employees
WHERE firstName IN ('Larry','Barry')
	OR lastName IN ('Larry','Barry');

-- Solution from web
SELECT  *
FROM employees
WHERE 'Larry' IN (lastName,firstName)
      OR 'Barry' IN (lastName,firstName);

-- 10. List the names of employees with non-alphabetic characters in their names.
SELECT *
FROM employees
WHERE CONCAT(firstname, ' ', lastname) REGEXP '[0-9%@]';

-- 11. List the vendors whose name ends in Diecast
SELECT *
FROM products
WHERE productVendor LIKE '%Diecast';