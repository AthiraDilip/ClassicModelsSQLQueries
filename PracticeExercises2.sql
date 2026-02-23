-- Source - https://github.com/mahmoudasem337/classicmodels/blob/main/simple%20queries.sql
SHOW DATABASES;
SELECT DATABASE();
USE classicmodels;
SHOW TABLES;

-- Ex1 - Simple - List Orders made between June 16, 2004 and July 7, 2005
SELECT * FROM orders ORDER BY orderDate DESC;
SELECT * FROM orders
WHERE orderDate BETWEEN '2004-06-16' AND '2005-07-07';
SELECT * FROM orders
WHERE orderDate >= '2004-06-16' AND orderDate <='2005-07-07';

-- Ex1 - Advanced - Find customers with the highest total orders.
SELECT customerName, SUM(quantityOrdered * priceEach) as totalOrders
FROM orderdetails
JOIN orders
	ON orders.orderNumber = orderdetails.orderNumber
JOIN customers
	ON customers.customerNumber = orders.customerNumber
GROUP BY customerName
ORDER BY totalOrders DESC;

-- Ex2 - Advanced - List employees who manage the most employees.
SELECT 
	m.employeeNumber AS managerNumber,
    CONCAT(m.firstName, ' ',m.lastName) AS managerName,
    COUNT(e.reportsTo) AS reporteesCount
FROM employees m
JOIN employees e
	ON m.employeeNumber = e.reportsTo
GROUP BY e.reportsTo
ORDER BY reporteesCount DESC;

-- Ex3 - Advanced - Get all customers who placed orders for more than 5 orders
SELECT
	customers.customerName,
    COUNT(*) AS ProductCount, 
    customers.customerNumber 
FROM orderdetails
JOIN orders
	ON orders.orderNumber = orderdetails.orderNumber
JOIN customers
	ON customers.customerNumber = orders.customerNumber
GROUP BY orders.customerNumber 
HAVING ProductCount >= 50;

-- Ex4 - Advanced - Identify customers who ordered products worth more than $10,000
SELECT SUM(quantityOrdered * priceEach) AS productWorth, customerNumber
FROM orderdetails
JOIN orders
	ON orders.orderNumber = orderdetails.orderNumber
GROUP BY customerNumber
HAVING productWorth >= 10000;

-- Ex5 - Advanced - Retrieve the top 5 most expensive products sold
-- My solution
SELECT DISTINCT productName, orderdetails.productCode, buyPrice
FROM orderdetails
JOIN products
	ON products.productCode = orderdetails.productCode
ORDER BY buyPrice DESC
LIMIT 5;

-- Solution in web
SELECT DISTINCT productCode, priceEach
FROM orderdetails
ORDER BY priceEach DESC
LIMIT 5;

-- Ex6 - Advanced - Find products not ordered by any customer
-- My solution
SELECT products.productCode,  productName
FROM products
LEFT JOIN orderdetails
	ON orderdetails.productCode = products.productCode
WHERE orderNumber IS NULL;

-- Solution in web
SELECT productCode, productName
FROM products
WHERE productCode NOT IN (SELECT DISTINCT productCode FROM orderdetails);
-- Same query using join
SELECT p.productCode, p.productName
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.productCode IS NULL;

-- Ex7 - Advanced - List products sold in the highest quantities
SELECT productCode, SUM(quantityOrdered) AS totalQuantity
FROM orderdetails
GROUP BY productCode
ORDER BY totalQuantity DESC;

-- Ex8 - Advanced - List employees who work in offices outside of the USA
-- My solution
SELECT 
employeeNumber,
CONCAT(firstName, ' ', lastName) AS employeeName,
officeCode AS nonUSAOfficeCode
FROM employees
WHERE officeCode IN (SELECT officeCode FROM offices WHERE country != 'USA');

-- Solution in web
SELECT employeeNumber, firstName, lastName, o.city, o.country
FROM employees
JOIN offices o ON employees.officeCode = o.officeCode
WHERE o.country not in
(SELECT o.country FROM offices o WHERE o.country = 'USA');
-- same query in simple way
SELECT employeeNumber, firstName, lastName, o.city, o.country
FROM employees
JOIN offices o ON employees.officeCode = o.officeCode
WHERE o.country != 'USA';

-- Ex9 - Advanced - List orders that include products from multiple product lines.
SELECT 
    COUNT(DISTINCT productLine) AS productLineCount,
    orderNumber
FROM products
JOIN orderdetails
	ON orderdetails.productCode = products.productCode
GROUP BY orderNumber
HAVING productLineCount > 1;