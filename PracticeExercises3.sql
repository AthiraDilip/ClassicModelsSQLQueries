-- Questions Source - https://github.com/Mikegr1990/ClassicModels-SQL-Solutions/tree/main/Single-Entity
-- A. Single Entity
SHOW DATABASES;
SELECT DATABASE();
USE classicmodels;
SHOW TABLES;

-- 1. Prepare a list of offices sorted by country, state, city
SELECT * FROM offices
ORDER BY country, state, city;

-- 2. How many employees are there in the company?
SELECT COUNT(DISTINCT employeeNumber) AS EmployeeCount
FROM employees;

-- 3. What is the total of payments received?
SELECT SUM(amount) AS totalPayments
FROM payments;

-- 4. List the product lines that contain 'Cars'
SELECT productLine AS Cars 
FROM productlines
WHERE productLine LIKE '%Cars%';

-- 5. Report total payments for November 18, 2004
SELECT SUM(amount) AS TotalPaymentForNov18_2004
FROM payments
WHERE paymentDate = '2003-11-18';

-- 6. Report those payments greater than $100,000
SELECT * 
FROM payments
WHERE amount > 100000;

-- 7. List the products in each product line
SELECT productName, productLine
FROM products
ORDER BY productLine;

-- 8. How many products in each product line?
SELECT 
COUNT(productName) AS ProductCount, 
productLine
FROM products
GROUP BY productLine;

-- 9. What is the minimum payment received?
SELECT
MIN(amount) AS minimum_payment
FROM payments;

-- 10. List all payments greater than twice the average payment.
SELECT *
FROM payments
WHERE amount > 2 * (SELECT AVG(amount) FROM payments);

-- 11. What is the average percentage markup of the MSRP on buyPrice?
SELECT AVG((MSRP - buyPrice) / MSRP) * 100 AS 'Average Percentage Markup'
FROM products;

-- 12. How many distinct products does ClassicModels sell?
SELECT COUNT(DISTINCT productName) AS DistinctProducts
FROM products;

-- 13. Report the name and city of customers who don't have sales representatives?
SELECT customerName, city
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

-- 14. What are the names of executives with VP or Manager in their title? Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
SELECT 
CONCAT(firstName, ' ', lastName) AS employeeName,
jobTitle
FROM employees
WHERE jobTitle LIKE '%VP%' OR jobTitle LIKE '%Manager%';

-- 15. Which orders have a value greater than $5,000?
SELECT quantityOrdered * priceEach AS OrderValue
FROM orderdetails
WHERE quantityOrdered * priceEach > 5000;

