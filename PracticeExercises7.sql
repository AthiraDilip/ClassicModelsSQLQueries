-- Questions Source - https://github.com/Mikegr1990/ClassicModels-SQL-Solutions/blob/main/Correlated-Subqueries/
-- Correlated-Subqueries Vs Using CTE & WindowFunctions
SHOW DATABASES;
SELECT DATABASE();
USE classicmodels;
SHOW TABLES;

-- 1. Who reports to Mary Patterson?
SELECT *
FROM employees
WHERE reportsTo = (SELECT employeeNumber FROM employees WHERE firstName = 'Mary' AND lastName = 'Patterson');

-- 2. Which payments in any month and year are more than twice the average for that month and year (i.e. compare all payments in Oct 2004 with the average payment for Oct 2004)? Order the results by the date of the payment. You will need to use the date functions.
-- CTE for my solution
SELECT
	customerNumber,
    checkNumber,
    paymentDate,
    amount,
    AVG(amount) OVER (PARTITION BY YEAR(paymentDate), MONTH(paymentDate)) AS monthlyAverage,
    CONCAT (MONTH(paymentDate), '-', YEAR(paymentDate))  AS 'monthWithYear',
	AVG(amount) OVER (PARTITION BY YEAR(paymentDate)) AS yearlyAverage,
	YEAR(paymentDate) AS 'year'
FROM payments;
-- My solution
WITH employeesWithAverage AS
(
SELECT
	customerNumber,
    checkNumber,
    paymentDate,
    amount,
    AVG(amount) OVER (PARTITION BY YEAR(paymentDate), MONTH(paymentDate)) AS monthlyAverage,
    CONCAT (MONTH(paymentDate), '-', YEAR(paymentDate))  AS 'monthWithYear',
	AVG(amount) OVER(PARTITION BY YEAR(paymentDate)) AS yearlyAverage,
	YEAR(paymentDate) AS 'year'
FROM payments
)
SELECT
*
FROM employeesWithAverage
WHERE amount > 2 * monthlyAverage
ORDER BY paymentDate;

-- Solution from web
SELECT
	p.customerNumber,
    p.paymentDate,
    p.amount
FROM payments p
WHERE p.amount > 2 * (
		SELECT AVG(p2.amount)
        FROM payments p2
        WHERE MONTH(p2.paymentDate) = MONTH(p.paymentDate)
        AND YEAR(p2.paymentDate) = YEAR(p.paymentDate)
)
ORDER BY p.paymentDate;

-- 3. Report for each product, the percentage value of its stock on hand as a percentage of the stock on hand for product line to which it belongs. Order the report by product line and percentage value within product line descending. Show percentages with two decimal places.
-- My solution
SELECT
	*,
    ROUND (quantityInStock/SUM(quantityInStock) OVER(PARTITION BY productline) * 100, 2) AS percentageStockInEachProductLine,
	SUM(quantityInStock) OVER(PARTITION BY productline) AS totalQuantityInStockInEachProductLine
FROM products
ORDER BY productLine, percentageStockInEachProductLine DESC;

-- Solution from web
SELECT 
	productName,
    productLine,
    quantityInStock,
    ROUND((quantityInstock / (
		SELECT SUM(p2.quantityInStock)
        FROM products p2
        WHERE p2.productLine = p1.productLine
    )) * 100, 2) AS stock_percentage
FROM products p1
ORDER BY productLine, stock_percentage DESC;

-- 4. For orders containing more than two products, report those products that constitute more than 50% of the value of the order.
-- CTE for my solution
SELECT
	orderNumber,
    productCode,
    quantityOrdered,
    priceEach,
	COUNT(productCode) OVER(PARTITION BY orderNumber) AS productsOrderedCount,
    SUM(quantityOrdered * priceEach) OVER(PARTITION BY orderNumber) AS totalValueofEachOrder,
	SUM(quantityOrdered * priceEach) OVER(PARTITION BY orderNumber, productCode) AS totalValueofEachProductInTheOrder
FROM orderdetails;

-- My Solution
WITH productDetailsPerOrderPerProduct AS(
SELECT
	orderNumber,
    productCode,
    quantityOrdered,
    priceEach,
	COUNT(productCode) OVER(PARTITION BY orderNumber) AS productsOrderedCount,
    SUM(quantityOrdered * priceEach) OVER(PARTITION BY orderNumber) AS totalValueofEachOrder,
	SUM(quantityOrdered * priceEach) OVER(PARTITION BY orderNumber, productCode) AS totalValueofEachProductInTheOrder
FROM orderdetails
)
SELECT
	*
FROM productDetailsPerOrderPerProduct
WHERE 
totalValueofEachProductInTheOrder > 0.5 * totalValueofEachOrder
AND
productsOrderedCount > 2;

-- Solution from web
SELECT 
	od.orderNumber, 
    od.productCode, 
    (od.priceEach * od.quantityOrdered) AS product_value,
    ROUND((od.priceEach * od.quantityOrdered) /
		(SELECT SUM(od2.priceEach * od2.quantityOrdered)
		 FROM orderdetails od2
		 WHERE od2.orderNumber = od.orderNumber) * 100, 2) AS product_percentage
FROM orderdetails od
WHERE
	(od.priceEach * od.quantityOrdered) >
    (SELECT SUM(od2.priceEach * od2.quantityOrdered) * 0.5
    FROM orderdetails od2
    WHERE od2.orderNumber = od.orderNumber)
AND od.orderNumber IN (
	SELECT orderNumber
    FROM orderdetails
    GROUP BY orderNumber
    HAVING COUNT(DISTINCT productCode) > 2
)
ORDER BY od.orderNumber, product_percentage DESC;
