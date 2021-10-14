/*
# SQL Developer Notes
*/

/*
This Azure Data Studio Notebook covers pretty much everything I've every had to do with SQL. You will need to download and restore the AventureWorks sample database from Microsoft to be able to run the queries.

Download AventureWorks sample database: [https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)

Other Sample Databases: [https://github.com/microsoft/sql-server-samples/tree/master/samples/databases](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases)

## **Useful References**

**RTFM** [https://docs.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver15)

**Data Types** [https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15)

**Execution Plans** [https://docs.microsoft.com/en-us/sql/relational-databases/performance/execution-plans?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/relational-databases/performance/execution-plans?view=sql-server-ver15)

**IO & Time Statistics** [https://www.mssqltips.com/sqlservertip/1255/getting-io-and-time-statistics-for-sql-server-queries/](https://www.mssqltips.com/sqlservertip/1255/getting-io-and-time-statistics-for-sql-server-queries/)

**Normalization** [https://database.guide/what-is-normalization/](https://database.guide/what-is-normalization/)
*/

/*
# **Useful Queries**
*/

/*
## **Get all tables with a given column**
*/

USE AdventureWorks2019;
GO

declare @catalog varchar(max) = 'AdventureWorks2019'
declare @col varchar(max) = 'BusinessEntityID'


SELECT Table_Name, Column_Name  
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = @catalog 
AND COLUMN_NAME = @col
ORDER BY TABLE_NAME

/*
**BEGIN TRANSACTION**



Marks the starting point of an explicit, local transaction. Explicit transactions start with the BEGIN TRANSACTION statement and end with the COMMIT or ROLLBACK statement.
*/

use AdventureWorks2019
go

select * FROM HumanResources.JobCandidate  
    WHERE JobCandidateID = 13;  

BEGIN TRANSACTION;  
DELETE FROM HumanResources.JobCandidate  
    WHERE JobCandidateID = 13;  
ROLLBACK
--COMMIT;  


select * FROM HumanResources.JobCandidate  
    WHERE JobCandidateID = 13;  

/*
## **Debugging Tools**
*/

/*
### **PRINT** Returns a user-defined message to the client.
*/

DECLARE @PrintMessage NVARCHAR(50);  
SET @PrintMessage = N'This message was printed on '  
    + RTRIM(CAST(GETDATE() AS NVARCHAR(30)))  
    + N'.';  
PRINT @PrintMessage;  
GO  

/*
**TRY CATCH**



Example from [https://www.sqlshack.com/how-to-implement-error-handling-in-sql-server/](https://www.sqlshack.com/how-to-implement-error-handling-in-sql-server/)
*/

USE AdventureWorks2019
GO
-- Basic example of TRY...CATCH
 
BEGIN TRY
-- Generate a divide-by-zero error  
  SELECT
    1 / 0 AS Error;
END TRY
BEGIN CATCH
  SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

/*
# **Basics**
*/

/*
### **SELECT**
*/

USE AdventureWorks2019

-- use aliases for table names
SELECT 
p.*
FROM
Person.Person p
WHERE
p.LastName 
LIKE
'A%'
--NOT
AND
p.Title IN('Mr.', 'Mrs')
OR
p.ModifiedDate 
BETWEEN
'2013-01-01'
AND
'2014-01-01'
ORDER BY
p.LastName

/*
### **JOINS**
*/

/*
### **INNER JOIN** Data that exists in both tables
*/

select 
s.Name as StoreName
, s.SalesPersonID
, p.Title
, p.FirstName
, p.LastName
from Sales.Store s
INNER JOIN Sales.SalesPerson sp on sp.BusinessEntityID = s.SalesPersonID
INNER JOIN Person.Person p on p.BusinessEntityID = sp.BusinessEntityID


/*
### **LEFT JOIN** Data that exists in both tables and all of the rows from the table in the FROM clause
*/

USE AdventureWorks2019

-- LEFT JOIN Returns Data that exists in both tables and ALL of the rows from the table in the From Clause
-- select COUNT(*) from Person.Person 

select 
p.BusinessEntityID as PersonBusinessEntityID
, sp.BusinessEntityID as SalesPersonBusinessEntityID
, p.FirstName
, p.LastName
, p.PersonType
from
Person.Person p
 LEFT JOIN 
Sales.SalesPerson sp on sp.BusinessEntityID = P.BusinessEntityID

/*
**RIGHT JOIN** Data that exists in both tables and all of the rows from the table in the JOIN clause
*/

USE AdventureWorks2019

-- LEFT JOIN Returns Data that exists in both tables and ALL of the rows from the table in the JOIN Clause
-- select COUNT(*) from Sales.SalesPerson

select 
p.BusinessEntityID as PersonBusinessEntityID
, sp.BusinessEntityID as SalesPersonBusinessEntityID
, p.FirstName
, p.LastName
, p.PersonType
from
Person.Person p
 right JOIN 
Sales.SalesPerson sp on sp.BusinessEntityID = P.BusinessEntityID



/*
**UNION** <span style="color: rgb(0, 0, 0); font-family: Verdana, sans-serif; font-size: 15px; background-color: rgb(255, 255, 255);">combines the result set of two or more SELECT statements (only distinct values)</span>
*/

SELECT 
p.BusinessEntityID
, p.FirstName
, p.LastName
FROM Person.Person p
UNION 
select
c.PersonID AS BusinessEntityID
, p.FirstName
, p.LastName
from
Sales.Customer c
JOIN Person.Person p on p.BusinessEntityID = C.PersonID

/*
**UNION ALL** <span style="color: rgb(0, 0, 0); font-family: Verdana, sans-serif; font-size: 15px; background-color: rgb(255, 255, 255);">command combines the result set of two or more SELECT statements (allows duplicate values).</span>
*/

SELECT 
p.BusinessEntityID
, p.FirstName
, p.LastName
FROM Person.Person p
UNION ALL
select
c.PersonID AS BusinessEntityID
, p.FirstName
, p.LastName
from
Sales.Customer c
JOIN Person.Person p on p.BusinessEntityID = C.PersonID

/*
<span style="font-size: 11pt; font-family: Arial; color: rgb(0, 0, 0); background-color: transparent; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"><b>SELF JOIN </b></span> <span style="color: rgb(0, 0, 0); font-family: Verdana, sans-serif; font-size: 15px; background-color: rgb(255, 255, 255);">A self join is a regular join, but the table is joined with itself.</span>



<span style="color: rgb(0, 0, 0); font-family: Verdana, sans-serif; font-size: 15px; background-color: rgb(255, 255, 255);">Example Reference:&nbsp;</span> [https://blog.sqlauthority.com/2007/06/03/sql-server-2005-explanation-and-example-self-join/](https://blog.sqlauthority.com/2007/06/03/sql-server-2005-explanation-and-example-self-join/)
*/

USE AdventureWorks2019;
GO
SELECT DISTINCT pv1.ProductID, pv1.BusinessEntityID
FROM Purchasing.ProductVendor pv1
INNER JOIN Purchasing.ProductVendor pv2
ON pv1.ProductID = pv2.ProductID
AND pv1.BusinessEntityID = pv2.BusinessEntityID
ORDER BY pv1.ProductID

/*
**CROSS JOIN** <span style="color: rgb(37, 37, 37); font-family: &quot;Segoe UI&quot;, Tahoma, Arial; background-color: rgb(255, 255, 255);">used to generate a paired combination of each row of the first table with each row of the second table. This join type is also known as cartesian join.</span>
*/

select * from Person.PersonPhone
cross join Person.PhoneNumberType

/*
### <span style="font-size: 11pt; font-family: Arial; color: rgb(0, 0, 0); background-color: transparent; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"><b>AGREGATIONS : </b>SUM, AVG, COUNT, MIN, MAX, GROUP BY, HAVING</span>
*/

/*
**SUM** Get the total of amount due of all purchase orders
*/

USE AdventureWorks2019;
GO
select 
SUM(po.TotalDue)
from Purchasing.PurchaseOrderHeader po

/*
**AVG** Get the average amount due for purchase orders
*/

USE AdventureWorks2019;
GO
select 
AVG(po.TotalDue)
from Purchasing.PurchaseOrderHeader po

/*
<span style="font-size: 11pt; font-family: Arial; color: rgb(0, 0, 0); background-color: transparent; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"><b>COUNT </b>Get total number of orders</span>
*/

USE AdventureWorks2019;
GO
select 
COUNT(po.TotalDue)
from Purchasing.PurchaseOrderHeader po

/*
<span style="font-size: 11pt; font-family: Arial; color: rgb(0, 0, 0); background-color: transparent; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"><b>MIN </b>Get the lowest total due amount</span>
*/

USE AdventureWorks2019;
GO
select 
MIN(po.TotalDue)
from Purchasing.PurchaseOrderHeader po

/*
<span style="font-size: 11pt; font-family: Arial; color: rgb(0, 0, 0); background-color: transparent; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"><b>MAX </b></span> <span style="color: rgb(0, 0, 0); font-family: Arial; font-size: 14.6667px; white-space: pre-wrap;">Get the highest total due amount</span>
*/

USE AdventureWorks2019;
GO
select 
MAX(po.TotalDue)
from Purchasing.PurchaseOrderHeader po

/*
**GROUP BY** <span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0); font-family: Verdana, sans-serif; font-size: 15px;">groups rows that have the same values into summary rows, like "find the number of customers in each country".</span>
*/

USE AdventureWorks2019;
GO
select 
c.AccountNumber
, p.Title
, p.FirstName
, p.LastName
, c.StoreID
, s.Name
from Sales.Customer c
join  Person.Person p on p.BusinessEntityID = c.CustomerID
JOIN  Sales.Store s on s.BusinessEntityID = c.StoreID
GROUP BY 
c.AccountNumber, p.Title, p.FirstName, p.LastName, c.StoreID, s.Name

/*
**HAVING** <span style="color: rgb(0, 0, 0); font-family: Verdana, sans-serif; font-size: 15px; background-color: rgb(255, 255, 255);">added to SQL because the&nbsp;</span> `WHERE` <span style="color: rgb(0, 0, 0); font-family: Verdana, sans-serif; font-size: 15px; background-color: rgb(255, 255, 255);">&nbsp;keyword cannot be used with aggregate functions</span>
*/

USE AdventureWorks2019;
GO
select 
c.AccountNumber
, p.Title
, p.FirstName
, p.LastName
, c.StoreID
, s.Name
from Sales.Customer c
join  Person.Person p on p.BusinessEntityID = c.CustomerID
JOIN  Sales.Store s on s.BusinessEntityID = c.StoreID
GROUP BY 
c.AccountNumber, p.Title, p.FirstName, p.LastName, c.StoreID, s.Name
HAVING COUNT(c.CustomerID) > 0

/*
## <span style="font-size: 11pt; font-family: Arial; color: rgb(0, 0, 0); background-color: transparent; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"><b>DATE FUNCTIONS</b></span>



> <span style="font-size: 14.6667px; white-space: pre-wrap;"><b>PostGresSQL and MySQL</b></span>



```

DATE_TRUNC('day', name of date column)

```

```

DATE_PART('day', 2017-04-01 12:15:01) returns day of weekD

```

```

ATE_PART('month', 2017-04-01 12:15:01) returns month

```

```

DATE_PART('year', 2017-04-01 12:15:01) returns year

```
*/

/*
**T-SQL Date Functions**
*/

declare @d datetime = getdate()

select @d

SELECT DATEPART(year, @d), DATEPART(month, @d), DATEPART(day, @d);  

/*
<span style="font-size: 11pt; font-family: Arial; color: rgb(0, 0, 0); background-color: transparent; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"><b>CASE STATEMENTS</b></span>
*/

USE AdventureWorks2019;
GO

CASE = IF THEN

SELECT account_id, total_amt_usd,
CASE WHEN total_amt_usd > 3000 THEN 'Large'
ELSE 'Small' END AS order_level
FROM orders;


/*
<span style="font-size: 11pt; font-family: Arial; color: rgb(0, 0, 0); background-color: transparent; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"><b>SUB QUERIES </b></span> Subqueries are queries that are nested inside of another query or statement
*/

use AdventureWorks2019
go
select 
p.ProductID
, p.Name
, p.ProductNumber
, 
(
 select AVG(Production.ProductListPriceHistory.ListPrice) 
 from Production.ProductListPriceHistory
 WHERE 
 ProductID = p.ProductID
) as AverageListPrice
from Production.Product p
WHERE
(
select AVG(Production.ProductListPriceHistory.ListPrice) 
 from Production.ProductListPriceHistory
 WHERE 
 ProductID = p.ProductID
) > 10.00

/*
<span style="font-size: 11pt; font-family: Arial; color: rgb(0, 0, 0); background-color: transparent; font-variant-numeric: normal; font-variant-east-asian: normal; vertical-align: baseline; white-space: pre-wrap;"><b>WITH : CTE (Common Table Expression) </b></span> <span style="background-color: transparent; color: rgb(0, 0, 0); font-family: Arial; font-size: 11pt; white-space: pre-wrap;">You can use a WITH statement to use the results of a sub query in the same way as any table</span>



We can put subqueries in the FROM clause and access the rows returned from them like any other table. For instance, if we want to know which employees have more vacation hours than average for their job title, we might write:<span style="background-color: transparent; color: rgb(0, 0, 0); font-family: Arial; font-size: 11pt; white-space: pre-wrap;"><br></span>



Example From: [https://www.mssqltips.com/sqlservertip/4728/introduction-to-subqueries-in-sql-server/](https://www.mssqltips.com/sqlservertip/4728/introduction-to-subqueries-in-sql-server/)
*/

use AdventureWorks2019
go


SELECT
  E1.BusinessEntityID,
  E1.LoginID,
  E1.JobTitle,
  E1.VacationHours,
  Sub.AverageVacation --Drawn from the subquery
FROM HumanResources.Employee E1
JOIN (SELECT
      JobTitle,
      AVG(VacationHours) AverageVacation
      FROM HumanResources.Employee E2
      GROUP BY JobTitle) sub
ON E1.JobTitle = Sub.JobTitle
WHERE E1.VacationHours > Sub.AverageVacation
ORDER BY E1.JobTitle

/*
## **Temporary Tables**



These can be very useful for ad hoc queries.  Technically the example below is a Table Variable see [https://www.c-sharpcorner.com/article/temporary-tables-and-table-variables-in-sql/](https://www.c-sharpcorner.com/article/temporary-tables-and-table-variables-in-sql/)
*/

use AdventureWorks2019
go

declare @tmp table
(
	Territory varchar(max),
	Store varchar(max),
	FirstName varchar(max),
	LastName varchar(max),
	SalesYTD varchar(max)
)

INSERT INTO @tmp

select 
t.Name as Territory
, st.Name as Store
, p.FirstName
, p.LastName
,sp.SalesYTD
from Sales.SalesPerson sp
JOIN Sales.SalesTerritory t on t.TerritoryID = sp.TerritoryID
JOIN Sales.Store st on st.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p on p.BusinessEntityID = sp.BusinessEntityID

select * from @tmp

/*

*/

/*
# Data Cleaning
*/

/*
**LEFT, RIGHT, LOWER, UPPER, CHARINDEX**
*/

select 
LOWER(p.FirstName) as FirstName
, UPPER( p.LastName) as LastName
, LEFT(p.LastName, 3) as FirstThreeLettersOfLastName
, RIGHT(p.LastName, 3) as LastThreeLettersOfLastName
, CHARINDEX('a', p.LastName) as IndexOfA
from Person.Person p

/*
**CONCAT**
*/

SELECT CONCAT( p.FirstName + ' ', p.LastName) AS FullName FROM  Person.Person p

/*
**CAST**
*/

SELECT CAST(25.65 AS int); 

/*
**COALESCE** Return the first non-null value in a list
*/

SELECT COALESCE(NULL, 1, 2, 0); 

/*
# WINDOW FUNCTIONS
*/

/*
**OVER** You can use the OVER clause with functions to compute aggregated values such as running totals.



See: [https://docs.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql?view=sql-server-ver15)



See: [https://blog.sqlauthority.com/2015/11/04/sql-server-what-is-the-over-clause-notes-from-the-field-101/](https://blog.sqlauthority.com/2015/11/04/sql-server-what-is-the-over-clause-notes-from-the-field-101/)
*/

select 
od.AccountNumber
, od.OrderDate
,
od.TotalDue,
	SUM(od.TotalDue) 
	OVER (order by od.OrderDate) as RunningTotal
from 
Sales.SalesOrderHeader od

/*
**LAG, LEAD**



**LAG** Returns <span style="background-color: transparent; color: rgb(0, 0, 0); font-family: Arial; font-size: 11pt; white-space: pre-wrap;">value from a previous row to the current row in the table</span>



**LEAD** Returns <span style="background-color: transparent; color: rgb(0, 0, 0); font-family: Arial; font-size: 11pt; white-space: pre-wrap;">value from the row following the current row in the table</span>
*/

select 
od.SalesOrderID
, od.OrderDate
, od.CustomerID
, od.SalesOrderID
, od.SubTotal
, od.TaxAmt
, od.TotalDue
, LAG(od.TotalDue) OVER (ORDER BY od.OrderDate) as PreviousOrderTotal
, LEAD(od.TotalDue) OVER (ORDER BY od.OrderDate) as NextOrderTotal
from 
Sales.SalesOrderHeader od
where od.AccountNumber = '10-4020-000676'

-- get difference between next order total and order in row
USE AdventureWorks2019;
GO  
select 
od.SalesOrderID
, od.OrderDate
, od.CustomerID
, od.SalesOrderID
, od.SubTotal
, od.TaxAmt
, od.TotalDue
, LEAD(od.TotalDue) OVER (ORDER BY od.OrderDate) as NextOrderTotal
, LEAD(od.TotalDue) OVER (ORDER BY od.OrderDate) - od.TotalDue as OrderTotalDifference
from 
Sales.SalesOrderHeader od

/*

*/

/*
**PARTITION BY** [https://docs.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql?view=sql-server-ver15)
*/

USE AdventureWorks2019;
GO  
SELECT ROW_NUMBER() OVER(PARTITION BY PostalCode ORDER BY SalesYTD DESC) AS "Row Number",   
    p.LastName, s.SalesYTD, a.PostalCode  
FROM Sales.SalesPerson AS s   
    INNER JOIN Person.Person AS p   
        ON s.BusinessEntityID = p.BusinessEntityID  
    INNER JOIN Person.Address AS a   
        ON a.AddressID = p.BusinessEntityID  
WHERE TerritoryID IS NOT NULL   
    AND SalesYTD <> 0  
ORDER BY PostalCode;  
GO

/*
**NTILE** Distributes the rows in an ordered partition into a specified number of groups. The groups are numbered, starting at one. For each row, NTILE returns the number of the group to which the row belongs.  See:[https://docs.microsoft.com/en-us/sql/t-sql/functions/ntile-transact-sql?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/t-sql/functions/ntile-transact-sql?view=sql-server-ver15)
*/

USE AdventureWorks2019;
GO  
SELECT p.FirstName, p.LastName  
    ,NTILE(4) OVER(ORDER BY SalesYTD DESC) AS Quartile  
    ,CONVERT(NVARCHAR(20),s.SalesYTD,1) AS SalesYTD  
    , a.PostalCode  
FROM Sales.SalesPerson AS s   
INNER JOIN Person.Person AS p   
    ON s.BusinessEntityID = p.BusinessEntityID  
INNER JOIN Person.Address AS a   
    ON a.AddressID = p.BusinessEntityID  
WHERE TerritoryID IS NOT NULL   
    AND SalesYTD <> 0;  
GO

/*
# Views



See: [https://docs.microsoft.com/en-us/sql/relational-databases/views/views?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/relational-databases/views/views?view=sql-server-ver15)
*/

/*
## Indexed Views



- SQL Server will used an indexed View even if it is not referenced in a query.

- Clustered Indexes (define order in which db pages are stored) . Nonclustered Indexes are HEAPS

- Clustered Indexes can be Rowstore or Columnstore. Rowstore being useful for OLTP systems, Columnstore for OLAP Analytics systems.
*/

USE [AdventureWorks2019]
GO

/****** Object:  View [Production].[vProductAndDescription]    Script Date: 14/10/2021 11:47:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Production].[vProductAndDescription] 
WITH SCHEMABINDING 
AS 
-- View (indexed or standard) to display products and product descriptions by language.
SELECT 
    p.[ProductID] 
    ,p.[Name] 
    ,pm.[Name] AS [ProductModel] 
    ,pmx.[CultureID] 
    ,pd.[Description] 
FROM [Production].[Product] p 
    INNER JOIN [Production].[ProductModel] pm 
    ON p.[ProductModelID] = pm.[ProductModelID] 
    INNER JOIN [Production].[ProductModelProductDescriptionCulture] pmx 
    ON pm.[ProductModelID] = pmx.[ProductModelID] 
    INNER JOIN [Production].[ProductDescription] pd 
    ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID];
GO


/*
## Partitioned Views



See: [https://docs.microsoft.com/en-us/sql/t-sql/statements/create-view-transact-sql?view=sql-server-ver15#partitioned-views](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-view-transact-sql?view=sql-server-ver15#partitioned-views)



  



See: [https://www.sqlshack.com/sql-server-partitioned-views/](https://www.sqlshack.com/sql-server-partitioned-views/)
*/

/*
# Stored Procedures



See: [https://docs.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver15)
*/

/*
_**\* You will need to run this script to create the Contacts Table**_
*/

USE [AdventureWorks2019]
GO

/****** Object:  Table [dbo].[Contacts]    Script Date: 14/10/2021 12:16:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Contacts](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](40) NULL,
	[LastName] [varchar](40) NULL,
	[DateOfBirth] [date] NULL,
	[AllowContactByPhone] [bit] NULL,
 CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/*
## INSERT RECORD & RETURN IDENTITY
*/

use AdventureWorks2019;

GO

DROP PROCEDURE IF EXISTS dbo.InsertContact;

GO

CREATE PROCEDURE dbo.InsertContact
(
@FirstName				VARCHAR(40),
@LastName				VARCHAR(40),
@DateOfBirth			DATE = NULL, -- default param : "= NULL"
@AllowContactByPhone	BIT

)
AS
BEGIN;

DECLARE @ContactId INT;

INSERT INTO dbo.Contacts(FirstName, LastName, DateOfBirth, AllowContactByPhone)
		VALUES(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);

-- return the record just created
--SELECT @ContactId = @@IDENTITY;
SELECT @ContactId = SCOPE_IDENTITY() ; -- ONLY USE ID OF LAST RECORD INSERTED FOR THIS PROC @@IDENTITY is for the whole DB
SELECT ContactId, FirstName, LastName, DateOfBirth, AllowContactByPhone
	FROM dbo.Contacts
WHERE ContactId = @ContactId

END;

GO


/*
**OUTPUT PARAMETER**
*/

use AdventureWorks2019;

GO

DROP PROCEDURE IF EXISTS dbo.InsertContact;

GO

CREATE PROCEDURE dbo.InsertContact
(
@FirstName				VARCHAR(40),
@LastName				VARCHAR(40),
@DateOfBirth			DATE = NULL, -- default param : "= NULL"
@AllowContactByPhone	BIT,
@ContactId				INT OUTPUT -- output parameter
)
AS
BEGIN;


INSERT INTO dbo.Contacts(FirstName, LastName, DateOfBirth, AllowContactByPhone)
		VALUES(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);

-- return the record just created
--SELECT @ContactId = @@IDENTITY;
SELECT @ContactId = SCOPE_IDENTITY() ; -- ONLY USE ID OF LAST RECORD INSERTED FOR THIS PROC @@IDENTITY is for the whole DB
SELECT ContactId, FirstName, LastName, DateOfBirth, AllowContactByPhone
	FROM dbo.Contacts
WHERE ContactId = @ContactId

END;

GO


-- and to call this example:


USE Contacts;

DECLARE @ContactIdOut INT;

EXEC dbo.InsertContact
@FirstName = 'Harry',
@LastName = 'Houdini',
--@DateOfBirth = '1935-05-06',
@AllowContactByPhone = 0,
@ContactId = @ContactIdOut OUTPUT; -- OUTPUT MUST BE ADDED TO OUTPUT PARAM DECLARATION

select * from dbo.Contacts WHERE ContactId = @ContactIdOut order by ContactId desc;

SELECT @ContactIdOut AS ContactIdOut;


/*
## NOCOUNT ON/OFF



[https://docs.microsoft.com/en-us/sql/t-sql/statements/set-statements-transact-sql?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/t-sql/statements/set-statements-transact-sql?view=sql-server-ver15)
*/

use AdventureWorks2019;

GO

DROP PROCEDURE IF EXISTS dbo.InsertContact;

GO

CREATE PROCEDURE dbo.InsertContact
(
@FirstName				VARCHAR(40),
@LastName				VARCHAR(40),
@DateOfBirth			DATE = NULL, -- default param : "= NULL"
@AllowContactByPhone	BIT,
@ContactId				INT OUTPUT -- output parameter
)
AS
BEGIN;

SET NOCOUNT ON; -- PREVENTS SENDING METADATA WITH RESULTS, REDUCES NETWORK TRAFFIC

INSERT INTO dbo.Contacts(FirstName, LastName, DateOfBirth, AllowContactByPhone)
		VALUES(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);

-- return the record just created
--SELECT @ContactId = @@IDENTITY;
SELECT @ContactId = SCOPE_IDENTITY() ; -- ONLY USE ID OF LAST RECORD INSERTED FOR THIS PROC @@IDENTITY is for the whole DB
SELECT ContactId, FirstName, LastName, DateOfBirth, AllowContactByPhone
	FROM dbo.Contacts
WHERE ContactId = @ContactId

SET NOCOUNT OFF; -- RESET TO DEFAULT

END;

GO


/*
## STORED PROCEDURE CHAIN
*/

USE AdventureWorks2019;

DROP PROCEDURE IF EXISTS dbo.SelectContact ;


GO


CREATE PROCEDURE dbo.SelectContact
(
	@ContactId INT
)
AS
BEGIN;

SET NOCOUNT ON;

SELECT ContactId, FirstName, LastName, DateOfBirth, AllowContactByPhone, CreatedDate 
	FROM dbo.Contacts
WHERE ContactId = @ContactId;

SET NOCOUNT OFF;

END;


use Contacts;

GO

DROP PROCEDURE IF EXISTS dbo.InsertContact;

GO

CREATE PROCEDURE dbo.InsertContact
(
@FirstName				VARCHAR(40),
@LastName				VARCHAR(40),
@DateOfBirth			DATE = NULL, -- default param : "= NULL"
@AllowContactByPhone	BIT,
@ContactId				INT OUTPUT -- output parameter
)
AS
BEGIN;

SET NOCOUNT ON; -- PREVENTS SENDING METADATA WITH RESULTS, REDUCES NETWORK TRAFFIC

INSERT INTO dbo.Contacts(FirstName, LastName, DateOfBirth, AllowContactByPhone)
		VALUES(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);

-- return the record just created
--SELECT @ContactId = @@IDENTITY;
SELECT @ContactId = SCOPE_IDENTITY() ; -- ONLY USE ID OF LAST RECORD INSERTED FOR THIS PROC @@IDENTITY is for the whole DB

EXEC dbo.SelectContact @ContactId = @ContactId;


SET NOCOUNT OFF; -- RESET TO DEFAULT

END;

GO


/*
## CONTROL FLOW
*/

use AdventureWorks2019;

GO

DROP PROCEDURE IF EXISTS dbo.InsertContact;

GO

CREATE PROCEDURE dbo.InsertContact
(
@FirstName				VARCHAR(40),
@LastName				VARCHAR(40),
@DateOfBirth			DATE = NULL, -- default param : "= NULL"
@AllowContactByPhone	BIT,
@ContactId				INT OUTPUT -- output parameter
)
AS
BEGIN;

SET NOCOUNT ON; -- PREVENTS SENDING METADATA WITH RESULTS, REDUCES NETWORK TRAFFIC


---- check if contact already exists
IF NOT EXISTS	(SELECT 1 FROM dbo.Contacts 
				 WHERE FirstName = @FirstName AND LastName = @LastName
				 AND DateOfBirth = @DateOfBirth)

BEGIN;
		INSERT INTO dbo.Contacts(FirstName, LastName, DateOfBirth, AllowContactByPhone)
		VALUES(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);


		-- return the record just created
		--SELECT @ContactId = @@IDENTITY;
		SELECT @ContactId = SCOPE_IDENTITY() ; -- ONLY USE ID OF LAST RECORD INSERTED FOR THIS PROC @@IDENTITY is for the whole DB

END;

EXEC dbo.SelectContact @ContactId = @ContactId;


SET NOCOUNT OFF; -- RESET TO DEFAULT

END;

GO


/*
# SCHEMA & SCHEMA BINDING



- [https://www.brentozar.com/archive/2010/05/why-use-schemas/](https://www.brentozar.com/archive/2010/05/why-use-schemas/)

- [https://docs.microsoft.com/en-us/sql/t-sql/statements/create-schema-transact-sql?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-schema-transact-sql?view=sql-server-ver15)

- [https://www.sqlshack.com/a-walkthrough-of-sql-schema/](https://www.sqlshack.com/a-walkthrough-of-sql-schema/)
*/

/*
# Indexes



- Index Types [https://docs.microsoft.com/en-us/sql/relational-databases/indexes/indexes?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/indexes?view=sql-server-ver15)

- SQL Server Index Architecture and Design Guide [https://docs.microsoft.com/en-us/sql/relational-databases/sql-server-index-design-guide?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/relational-databases/sql-server-index-design-guide?view=sql-server-ver15)
*/