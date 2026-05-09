-- ============================================
-- FACT SALES
-- ============================================

CREATE OR ALTER VIEW dbo.vw_fact_sales AS
SELECT
    od.OrderID,
    od.ProductID,
    o.CustomerID,
    o.EmployeeID,
    CAST(o.OrderDate AS DATE) AS OrderDate,
    od.UnitPrice,
    od.Quantity,
    od.Discount,
    od.Quantity * od.UnitPrice * (1 - od.Discount) AS SalesAmount
FROM dbo.[Order Details] od
LEFT JOIN dbo.Orders o
    ON od.OrderID = o.OrderID;
GO


-- ============================================
-- DIM PRODUCT
-- ============================================

CREATE OR ALTER VIEW dbo.vw_dim_product AS
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.QuantityPerUnit,
    p.UnitPrice AS CurrentUnitPrice,
    p.UnitsInStock,
    p.Discontinued
FROM dbo.Products p
LEFT JOIN dbo.Categories c
    ON p.CategoryID = c.CategoryID;
GO


-- ============================================
-- DIM CUSTOMER
-- ============================================

CREATE OR ALTER VIEW dbo.vw_dim_customer AS
SELECT 
    c.CustomerID,
    c.CompanyName,
    c.City,
    ISNULL(c.Region, 'Unknown') AS Region,
    c.Country
FROM dbo.Customers c;
GO


-- ============================================
-- DIM EMPLOYEE
-- ============================================

CREATE OR ALTER VIEW dbo.vw_dim_employee AS
SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    e.City,
    ISNULL(e.Region, 'Unknown') AS Region,
    e.Country
FROM dbo.Employees e;
GO


-- ============================================
-- DIM DATE
-- ============================================

CREATE OR ALTER VIEW dbo.vw_dim_date AS
WITH numbers AS (
    SELECT TOP (
        DATEDIFF(DAY, '1996-07-04', '1998-05-06') + 1
    )
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
),
dates AS (
    SELECT DATEADD(DAY, n, CAST('1996-07-04' AS DATE)) AS Date
    FROM numbers
)
SELECT
    Date,
    YEAR(Date) AS Year,
    MONTH(Date) AS MonthNumber,
    DATENAME(MONTH, Date) AS MonthName,
    DATEPART(QUARTER, Date) AS Quarter,
    CONCAT(YEAR(Date), '-', RIGHT('0' + CAST(MONTH(Date) AS VARCHAR(2)), 2)) AS YearMonth
FROM dates;
GO