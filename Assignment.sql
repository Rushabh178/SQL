USE classicmodels;

-- Day 3

-- 1)
SELECT * FROM customers;
SELECT customerNumber, customerName, State, creditLimit 
FROM customers 
WHERE state IS NOT NULL 
    AND creditLimit >= 50000 
    AND creditLimit <= 100000 
ORDER BY creditLimit DESC;

-- 2)
SELECT * FROM productlines;
SELECT DISTINCT productLine 
FROM products
WHERE productLine LIKE "%Cars"; 

-- Day 4

-- 1)
SELECT * FROM orders;
SELECT orderNumber, 
       status, 
       COALESCE(comments, '-') AS comments
FROM orders
WHERE status = 'Shipped';

-- 2)
SELECT employeeNumber,
       firstName,
       jobTitle,
       CASE 
           WHEN jobTitle = 'President' THEN 'P'
           WHEN jobTitle LIKE '%Sale% Manager%' THEN 'SM'
           WHEN jobTitle = 'Sales Rep' THEN 'SR'
           WHEN jobTitle LIKE '%VP%' THEN 'VP'
           ELSE jobTitle 
       END AS jobTitleAbbreviation
FROM employees 
ORDER BY jobTitle ASC;

-- Day 5

-- 1)
SELECT * FROM payments;
SELECT YEAR(paymentDate) AS Year, MIN(amount) AS MinAmount 
FROM payments 
GROUP BY YEAR(paymentDate) 
ORDER BY Year ASC;

-- 2)
SELECT * FROM orders;
SELECT 
    YEAR(orderDate) AS Year,
    CONCAT('Q', QUARTER(orderDate)) AS Quarter,
    COUNT(DISTINCT customerNumber) AS 'Unique Customers',
    COUNT(orderNumber) AS 'Total Orders'
FROM orders
GROUP BY 
    Year,
    Quarter;

-- 3)
SELECT * FROM payments;
SELECT 
    DATE_FORMAT(paymentDate, '%b') AS Month,
    CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS 'Formatted Amount'
FROM payments
GROUP BY Month
HAVING SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY SUM(amount) DESC;

-- Day 6

-- 1)
CREATE TABLE journey (
    Bus_ID INT PRIMARY KEY NOT NULL,
    Bus_Name VARCHAR(255) NOT NULL,
    Source_Station VARCHAR(255) NOT NULL,
    Destination VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL
);
SELECT * FROM journey;
DESC journey;
 -- 2)
 CREATE TABLE vendor (
    Vendor_ID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Country VARCHAR(255) DEFAULT 'N/A'
);
SELECT * FROM vendor;
DESC vendor;
-- 3)
CREATE TABLE movies (
    Movie_ID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Release_Year VARCHAR(4) DEFAULT '-',
    Cast VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,
    No_of_shows INT CHECK (No_of_shows >= 0) NOT NULL
);
SELECT * FROM movies;
DESC movies;
-- 4)
-- a)
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255),
    location VARCHAR(255)
);
-- b)
CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) UNIQUE NOT NULL,
    description VARCHAR(255),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);
-- c)
CREATE TABLE Stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- Day 7
SELECT * FROM employees;
SELECT * FROM customers;
-- 1)
SELECT 
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS SalesPerson,
    COUNT(DISTINCT c.customerNumber) AS UniqueCustomers
FROM 
    Employees e
JOIN 
    Customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY 
    e.employeeNumber, SalesPerson
ORDER BY 
    UniqueCustomers DESC;

-- 2)
SELECT 
    o.customerNumber,
    c.customerName,
    od.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS TotalQuantities,
    p.quantityInStock AS TotalQuantitiesInStock,
    p.quantityInStock - SUM(od.quantityOrdered) AS LeftOverQuantities
FROM 
    Customers c
JOIN 
    Orders o ON c.customerNumber = o.customerNumber
JOIN 
    Orderdetails od ON o.orderNumber = od.orderNumber
JOIN 
    Products p ON od.productCode = p.productCode
GROUP BY 
    o.customerNumber, od.productCode, p.productName, TotalQuantitiesInStock
ORDER BY 
    o.customerNumber, od.productCode;

-- 3)
-- Create Laptop table
CREATE TABLE Laptop (
    Laptop_Name VARCHAR(50) PRIMARY KEY
);

-- Insert some data into Laptop table
INSERT INTO Laptop (Laptop_Name)
VALUES 
    ('LaptopA'),
    ('LaptopB'),
    ('LaptopC');
SELECT * FROM Laptop;
-- Create Colours table
CREATE TABLE Colours (
    Colour_Name VARCHAR(20) PRIMARY KEY
);

-- Insert some data into Colours table
INSERT INTO Colours (Colour_Name)
VALUES 
    ('Red'),
    ('Blue'),
    ('Green');
SELECT * FROM Colours;
-- Perform Cross Join and find the number of rows
SELECT 
    *
FROM 
    Laptop
CROSS JOIN 
    Colours;

-- 4)
CREATE TABLE Project (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    Gender VARCHAR(10),
    ManagerID INT
);

INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

SELECT
    M.FullName AS ManagerName,
    E.FullName AS EmployeeName
FROM
    Project M
LEFT JOIN
    Project E ON E.ManagerID = M.EmployeeID
WHERE
    E.ManagerID IS NOT NULL;

-- Day 8
-- i) 
CREATE TABLE facility (
    Facility_ID INT,
    Name VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    PRIMARY KEY (Facility_ID)
);

-- ii)
ALTER TABLE facility
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT;

-- ii) 
ALTER TABLE facility
ADD COLUMN City VARCHAR(255) NOT NULL AFTER Name;

DESC facility;

-- Day 9
-- Create the university table
CREATE TABLE University (
    ID INT PRIMARY KEY,
    Name VARCHAR(255)
);


INSERT INTO University
VALUES 
    (1, "       Pune          University     "), 
    (2, "  Mumbai          University     "),
    (3, "     Delhi   University     "),
    (4, "Madras University"),
    (5, "Nagpur University");
SELECT * FROM University;
set sql_safe_updates=0;
UPDATE University
SET Name = TRIM(BOTH ' ' FROM REGEXP_REPLACE(Name, ' {1,}',  ' '))
WHERE id IS NOT NULL;


-- Day 10

SELECT * from products;


CREATE VIEW products_status AS
select
YEAR(O.ORDERDATE) as year,
concat(
round (count(od.quantityOrdered *od.priceEach)),
' (',
round ((sum(od.quantityOrdered *od.priceEach) /sum(sum(od.quantityOrdered *od.priceEach)) over ()) *100),
'%)'
) as "total Values"
from orders O
join
orderdetails od
on o.ordernumber = od.ordernumber
group by YEAR(O.ORDERDATE);

SELECT * FROM classicmodels.products_status;
 -- Day 11
 
 -- 1)
 call classicmodels.GetCustomerLevel(121);
 
 -- 2)
call classicmodels.Get_country_payments(2003, 'France');

-- Day 12

-- 1)
WITH X AS (
    SELECT
        YEAR(ORDERDATE) AS Year,
        MONTHNAME(ORDERDATE) AS Month,
        COUNT(ORDERDATE) AS Total_Orders
    FROM
        orders
    GROUP BY
        YEAR, MONTH
)
SELECT
    Year,
    Month,
    Total_Orders AS 'Total Orders',
    CONCAT(
        ROUND(
            100 * (
                (Total_Orders - LAG(Total_Orders) OVER (ORDER BY Year))
                / LAG(Total_Orders) OVER (ORDER BY Year)
            ),
            0
        ),
        ' %'
    ) AS '% YoY Changes'
FROM X;

-- 2)

CREATE TABLE emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(200),
    DOB DATE
);

INSERT INTO emp_udf (Name, DOB)
VALUES
    ('Piyush', '1990-03-30'),
    ('Aman', '1992-08-15'),
    ('Meena', '1998-07-28'),
    ('Ketan', '2000-11-21'),
    ('Sanjay', '1995-05-21');
    
SELECT * FROM emp_udf;

DELIMITER //
CREATE FUNCTION calculate_age(date_of_birth DATE) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(50);

    SET years = TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, date_of_birth, CURDATE()) % 12;

    SET age = CONCAT(years, ' years ', months, ' months');

    RETURN age;
END //
DELIMITER ;

SELECT *, calculate_age(dob) as age FROM emp_udf;


-- Day 13
-- 1)


SELECT 
    customerNumber,
    customerName
FROM 
    customers
WHERE 
    customerName NOT IN (
        SELECT 
            customerNumber
        FROM 
            Orders
    );

-- 2)

SELECT c.customerNumber, c.customerName, COUNT(o.ordernumber) AS 'Total Orders'
FROM Customers c
LEFT JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName

UNION
SELECT c.customerNumber, c.customerName, 0 AS 'Total Orders'
FROM Customers c
WHERE c.customerNumber NOT IN (SELECT DISTINCT customerNumber FROM Orders)

UNION
SELECT o.customerNumber, NULL AS customerName, COUNT(o.ordernumber) AS 'Total Orders'
FROM Orders o 
WHERE o.customerNumber NOT IN (SELECT DISTINCT customerNumber FROM Customers) 
GROUP BY o.customerNumber;

-- 3)
select * from orderDetails;
select ordernumber, max(quantityOrdered) as quantityOrdered
from orderDetails o
where quantityOrdered < 
(Select max(quantityOrdered) 
from orderDetails od
where od.orderNumber = o.orderNumber)
group by orderNumber;


-- 4)

SELECT
	OrderNumber, 
	COUNT(OrderNumber) AS TotalProduct
FROM Orderdetails
GROUP BY OrderNumber
HAVING COUNT (OrderNumber) > 0;
SELECT
	MAX(TotalProduct) AS 'Max (Total)', MIN(TotalProduct) AS 'Min(Total)'
	FROM (
		SELECT
		OrderNumber, COUNT(OrderNumber) AS TotalProduct
		FROM Orderdetails
		GROUP BY OrderNumber
		HAVING COUNT(OrderNumber) > 0
	)
	AS ProductCounts;
    
-- 5)

SELECT productline , COUNT(*) AS Total
FROM products
WHERE BuyPrice > (
	SELECT avg(BuyPrice)
    FROM products
)
GROUP BY productline;

-- Day 14

CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(255),
    EmailAddress VARCHAR(255)
);
SELECT * from Emp_EH;

DELIMITER //

CREATE PROCEDURE AddEmployee(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(255),
    IN p_EmailAddress VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- This block executes in case of any error
        SELECT 'Error occurred';
        ROLLBACK; -- Optional: Rollback the transaction if necessary
    END;

    START TRANSACTION;

    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);

    COMMIT;
END //

DELIMITER ;

call classicmodels.AddEmployee(123, 'Rushabh', 'shrishrimalrushabh@gmail.com');

-- Day 15

CREATE TABLE Emp_BIT (
    Name VARCHAR(50),
    Occupation VARCHAR(50),
    Working_date DATE,
    Working_hours INT
);


SELECT * FROM Emp_BIT;

INSERT INTO Emp_BIT VALUES
    ('Robin', 'Scientist', '2020-10-04', 12),  
    ('Warner', 'Engineer', '2020-10-04', 10),  
    ('Peter', 'Actor', '2020-10-04', 13),  
    ('Marco', 'Doctor', '2020-10-04', 14),  
    ('Brayden', 'Teacher', '2020-10-04', 12),  
    ('Antonio', 'Business', '2020-10-04', 11);


DELIMITER //

CREATE TRIGGER before_insert_emp_bit
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END//

DELIMITER ;

SELECT * FROM Emp_BIT;