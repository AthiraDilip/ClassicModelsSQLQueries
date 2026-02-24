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

-- 3. List all the products purchased by Herkku Gifts.
SELECT DISTINCT productName, customerName
FROM products
JOIN orderdetails
	ON orderdetails.productCode = products.productCode
JOIN orders
	ON orders.orderNumber = orderdetails.orderNumber
JOIN customers
	ON customers.customerNumber = orders.customerNumber
WHERE customerName = 'Herkku Gifts';

-- 4. Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. Sort by employee last name and first name.
SELECT SUM(od.priceEach * od.quantityOrdered * 0.05) AS comission, CONCAT(e.lastName, ' ', e.firstName) AS sales_representative
FROM orderdetails od
JOIN orders o ON od.orderNumber = o.orderNumber
JOIN customers c ON o.customerNumber = c.customerNumber
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
GROUP BY e.employeeNumber, e.lastName, e.firstName
ORDER BY e.lastName, e.firstName;

-- 5. What is the difference in days between the most recent and oldest order date in the Orders file?
SELECT DATEDIFF(MAX(orderDate), MIN(orderDate)) AS days_difference
FROM orders;

-- 6. Compute the average time between order date and ship date for each customer ordered by the largest difference.
SELECT
	customerName,
	AVG(DATEDIFF(shippedDate, orderDate)) AS largestDifference
FROM orders
JOIN customers
	ON customers.customerNumber = orders.customerNumber
GROUP BY customers.customerNumber
ORDER BY largestDifference DESC;

-- 7. What is the value of orders shipped in August 2004? (Hint).
SELECT
	SUM(quantityOrdered * PriceEach) AS totalValue
FROM orderdetails
JOIN orders
	ON orders.orderNumber = orderdetails.orderNumber
WHERE shippedDate BETWEEN '2004-08-01' AND '2004-08-31';

-- 8. Compute the total value ordered, total amount paid, and their difference for each customer for orders placed in 2004 and payments received in 2004 (Hint; Create views for the total paid and total ordered).
SELECT
	customers.customerName,
	SUM(quantityOrdered * priceEach) AS totalValueOrdered,
    SUM(amount) AS totalAmountPaid,
    SUM(quantityOrdered * priceEach) - SUM(amount) AS difference
FROM orderdetails
JOIN orders
	ON orders.orderNumber = orderdetails.orderNumber
JOIN customers
	ON customers.customerNumber = orders.customerNumber
JOIN payments
	ON payments.customerNumber = customers.customerNumber
WHERE orderDate BETWEEN '2004-01-01' AND '2004-12-31'
AND paymentDate BETWEEN '2004-01-01' AND '2004-12-31'
GROUP BY customers.customerNumber
ORDER BY difference DESC;

