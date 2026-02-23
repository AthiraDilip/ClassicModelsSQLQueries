-- Questions Source - https://github.com/Mikegr1990/ClassicModels-SQL-Solutions/tree/main/Many-to-Many-Relationship
-- C. Many to many relationship
SHOW DATABASES;
SELECT DATABASE();
USE classicmodels;
SHOW TABLES;
-- 1. List products sold by order date
SELECT 
	orders.orderNumber,
    products.productCode,
    productName,
    orderDate,
    DAYNAME(orderDate) AS Day
FROM orderdetails
JOIN orders 
	ON orders.orderNumber = orderdetails.orderNumber
JOIN products
	ON products.productCode = orderdetails.productCode
ORDER BY orderDate DESC;

-- 2. List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
SELECT 
    DISTINCT productName,
    orderDate
FROM orderdetails
JOIN orders 
	ON orders.orderNumber = orderdetails.orderNumber
JOIN products
	ON products.productCode = orderdetails.productCode
WHERE productName = '1940 Ford Pickup Truck'
ORDER BY orderDate DESC;

-- 3. List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000?
-- My solution
SELECT 
	customerName,
    orders.orderNumber,
    quantityOrdered*priceEach AS totalValue
FROM orderdetails
JOIN orders
	ON orders.orderNumber = orderdetails.orderNumber
JOIN customers
	ON customers.customerNumber = orders.customerNumber
WHERE quantityOrdered*priceEach > 25000;

-- Solution on web
SELECT od.productCode
FROM orderdetails od
JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY od.productCode
HAVING COUNT(DISTINCT o.orderNumber) = (SELECT COUNT(DISTINCT orderNumber) FROM orders);

-- 4. Are there any products that appear on all orders?
SELECT
	orderdetails.productCode,
	productName,
	COUNT(DISTINCT orderdetails.orderNumber) as OrdersWithProduct
FROM orderdetails
JOIN orders
	ON orders.orderNumber = orderdetails.orderLineNumber
JOIN products
	ON products.productCode = orderdetails.productCode
GROUP BY productCode
HAVING OrdersWithProduct = (SELECT COUNT(DISTINCT orderNumber) FROM orders);

-- 5. List the names of products sold at less than 80% of the MSRP
SELECT
	productName,
	priceEach AS sellingPrice,
	0.8 * MSRP AS '80%MSRP',
    MSRP
FROM products
JOIN orderdetails
	ON orderdetails.productCode = products.productCode
WHERE priceEach < 0.8 * MSRP;

-- 6. Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)
SELECT
	productName,
	priceEach AS 'sellingPrice_PriceEach',
	2 * buyPrice AS 'twiceBuyPrice',
    MSRP
FROM products
JOIN orderdetails
	ON orderdetails.productCode = products.productCode
WHERE priceEach >= 2 * buyPrice;

-- 7. List the products ordered on a Monday
SELECT
	productName
	orderDate,
    DAYNAME(orderDate) AS dayOrdered,
    orders.orderNumber,
    orderdetails.productCode
FROM orders
JOIN orderdetails
	ON orderdetails.orderNumber = orders.orderNumber
JOIN products
	ON orderdetails.productCode = products.productCode
WHERE DAYNAME(orderDate) = 'Monday';

-- 8. What is the quantity on hand for products listed on 'On Hold' orders?
SELECT
	products.productCode,
    productName,
    status,
    quantityInStock,
    orders.orderNumber
FROM orders
JOIN orderdetails
	ON orderdetails.orderNumber = orders.orderNumber
JOIN products
	ON products.productCode = orderdetails.productCode
WHERE status = 'On Hold';