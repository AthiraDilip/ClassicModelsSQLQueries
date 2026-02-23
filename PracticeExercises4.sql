-- Questions Source - https://github.com/Mikegr1990/ClassicModels-SQL-Solutions/tree/main/One-to-Many-Relationship
-- B. One to many relationship
SHOW DATABASES;
SELECT DATABASE();
USE classicmodels;
SHOW TABLES;

-- 1. Report the account representative for each customer
SELECT
customerName,
CONCAT(firstName, ' ', lastName) AS accountRepresentative,
salesRepEmployeeNumber
FROM customers
LEFT JOIN employees
	ON employees.employeeNumber = customers.salesRepEmployeeNumber;
    
-- 2. Report total payments for customer - Atelier graphique
SELECT SUM(amount) AS totalPayments, customerName
FROM payments
JOIN customers
	ON customers.customerNumber = payments.customerNumber
WHERE customerName = 'Atelier graphique';

-- 3. Report the total payments by date
SELECT SUM(amount) totalPaymentByDate
FROM payments
GROUP BY paymentDate;

-- 4. Report the products that have not been sold
-- My solution
SELECT productName, orderNumber
FROM products
LEFT JOIN orderdetails
	ON orderdetails.productCode = products.productCode
WHERE orderNumber IS NULL;

-- Solution provided in web
SELECT *
FROM products p
WHERE NOT EXISTS (
	SELECT *
	FROM orderdetails o
	WHERE p.productcode = o.productcode
);

-- 5. List the amount paid by each customer
SELECT 
	SUM(amount), 
	payments.customerNumber
FROM payments
JOIN customers
	ON customers.customerNumber = payments.customerNumber
GROUP BY payments.customerNumber;

-- 6. How many orders have been placed by Herkku Gifts?
SELECT
	COUNT(orderNumber) AS orderCount,
    customerName
FROM orders
JOIN customers
	ON customers.customerNumber = orders.customerNumber
WHERE customerName = 'Herkku Gifts';

SELECT
	COUNT(orderNumber) AS orderCount, 
    customerName
FROM orders
JOIN customers
	ON customers.customerNumber = orders.customerNumber
GROUP BY customerName
HAVING customerName = 'Herkku Gifts';

-- 7. Who are the employees in Boston?
SELECT
	CONCAT(firstName, ' ', lastName) AS employeeName,
    employees.officeCode
FROM employees
WHERE employees.officeCode = (SELECT officeCode FROM offices WHERE city = 'Boston');

SELECT
	CONCAT(firstName, ' ', lastName) AS employeeName,
    employees.officeCode,
    city
FROM employees
JOIN offices
	ON offices.officeCode = employees.officeCode
WHERE city = 'Boston';

-- 8. Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first
SELECT
	SUM(amount) as highPayments,
    customerName
FROM payments
JOIN customers
	ON customers.customerNumber = payments.customerNumber
WHERE amount > 100000
GROUP BY customerName
ORDER BY highPayments DESC;

-- 9. List the value of 'On Hold' orders
SELECT amount, orders.status
FROM orders
JOIN payments
	ON payments.customerNumber = orders.customerNumber
WHERE orders.status = 'On Hold';

-- 10. Report the number of orders 'On Hold' for each customer
SELECT 
	COUNT(orderNumber) AS ordersOnHold, 
    customerName, 
    orders.customerNumber
FROM orders
JOIN customers
	ON customers.customerNumber = orders.customerNumber
WHERE status = 'On Hold'
GROUP BY orders.customerNumber;





