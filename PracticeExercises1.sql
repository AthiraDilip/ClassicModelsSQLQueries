-- Questions Source - https://arvidyuen7.github.io/classicmodels/classicmodels_rmd.html

SHOW DATABASES;
SELECT DATABASE();
USE classicmodels;
SHOW TABLES;

-- UNION
DESC customers;
SELECT * FROM customers;

-- Ex1 - Population of the database - how many rows are in each table in the database

SELECT 'Customers' AS 'Table', COUNT(*) AS Num_Rows FROM customers
UNION
SELECT 'Employees' AS 'Table', COUNT(*) AS Num_Rows FROM employees
UNION 
SELECT 'Offices' AS 'Table', COUNT(*) AS Num_Rows FROM offices
UNION 
SELECT 'Order Details' AS 'Table', COUNT(*) AS Num_Rows FROM orderdetails
UNION 
SELECT 'Orders' AS 'Table', COUNT(*) AS Num_Rows FROM orders
UNION
SELECT 'Payments' AS 'Table', COUNT(*) AS Num_Rows FROM payments
UNION
SELECT 'Product Lines' AS 'Table', COUNT(*) AS Num_Rows FROM productlines
UNION
SELECT 'Products' AS 'Table', COUNT(*) AS Num_Rows FROM products;

-- Ex2 - Who are the highest spending customers
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM orderdetails;
SELECT * FROM payments;
SELECT * FROM payments ORDER BY amount DESC;

-- My solution
SELECT customers.customerNumber, customerName, SUM(amount) AS totalAmountSpent
FROM customers
INNER JOIN payments
	ON customers.customerNumber = payments.customerNumber
GROUP BY customers.customerNumber
ORDER BY totalAmountSpent DESC;

SELECT customerNumber, SUM(amount) AS totalAmountSpent
FROM payments
GROUP BY customerNumber
ORDER BY totalAmountSpent DESC;

-- Solution provided in web
SELECT  customerName,
        contactLastName,
        contactFirstname,
        city,
        state,
        SUM(quantityOrdered*priceEach) AS totalSpent,
        MAX(orderDate) AS LastOrder
FROM    orderdetails JOIN
        orders USING (orderNumber) JOIN
        customers USING (customerNumber)
GROUP BY    customerNumber
ORDER BY    totalSpent DESC;

