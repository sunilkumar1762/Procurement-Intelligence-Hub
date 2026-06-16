Create database Procurement_Analytics;
Use Procurement_Analytics;
Select TOP 20 * from dbo.Fact_PO_Transactions; WHERE PO_ID IS NULL;
Select TOP 1 * from dbo.Dim_Vendor;
Select TOP 1 * from dbo.Dim_PayStatus;
Select TOP 1 * from dbo.Dim_Department;
Select TOP 1 * from dbo.Dim_Date;
Select TOP 1 * from dbo.Dim_Category;
Select Count(*) AS Dup from dbo.Fact_PO_Transactions group by PO_ID Having Count(*) > 1;
ALTER TABLE dbo.Fact_PO_Transactions
ADD Transaction_ID INT IDENTITY(1,1);
SELECT * from dbo.Fact_PO_Transactions WHERE PO_ID IN ('PO0000008','PO0000008-DUP');
SELECT Count(*) from dbo.Fact_PO_Transactions WHERE PO_ID LIKE '%-DUP';
SELECT COUNT(*) AS Total_Rows, COUNT(DISTINCT (PO_ID)) AS Unique_Rows from dbo.Fact_PO_Transactions;
SELECT
    COUNT(DISTINCT PO_ID) AS UniquePOs,
    COUNT(DISTINCT InvoiceNumber) AS UniqueInvoices
FROM dbo.Fact_PO_Transactions;

# DATA PROFILING
  
    SELECT COUNT(*) AS TotalRows,
    COUNT(PO_ID) AS NonNull_PO_ID,
    COUNT(Vendor_ID) AS NonNull_Vendor_ID,
    COUNT(Category_ID) AS NonNull_Category_ID,
    COUNT(InvoiceNumber) AS NonNull_InvoiceNumber,
    COUNT(PO_Date) AS NonNull_PO_Date,
    COUNT(InvoiceDate) AS NonNull_InvoiceDate,
    COUNT(ActualPaymentDate) AS NonNull_ActualPayment
FROM Fact_PO_Transactions;

# Checking PO Status

SELECT PO_Status, COUNT(*) AS Rows
FROM dbo.Fact_PO_Transactions
GROUP BY PO_Status
ORDER BY Rows DESC;

SELECT TOP 20 PO_Date,PO_ApprovedDate,GoodsReceiptDate,InvoiceDate,PaymentDueDate,ActualPaymentDate
FROM dbo.Fact_PO_Transactions;

SELECT PO_Type,COUNT(*) AS TotalRows,COUNT(GoodsReceiptDate) AS RowsWithGRPO
FROM dbo.Fact_PO_Transactions
GROUP BY PO_Type;

SELECT TOP 20 PO_ID,Vendor_ID,InvoiceNumber,PO_Amount,PaidAmount
FROM dbo.Fact_PO_Transactions
WHERE PO_ID LIKE '%-DUP';

# Checking Pairs

SELECT * FROM dbo.Fact_PO_Transactions
WHERE PO_ID IN ('PO0000093','PO0000093-DUP');

SELECT * FROM dbo.Fact_PO_Transactions
WHERE PO_ID IN ('PO0000100','PO0000100-DUP');

SELECT * FROM dbo.Fact_PO_Transactions
WHERE PO_ID IN ('PO0000423','PO0000423-DUP');

# Referential Integrity

SELECT COUNT(*) AS Missing_Vendors from dbo.Fact_PO_Transactions
LEFT JOIN dbo.Dim_Vendor ON dbo.Fact_PO_Transactions.Vendor_ID = dbo.Dim_Vendor.Vendor_ID
where dbo.Dim_Vendor.Vendor_ID IS NULL;

SELECT COUNT(*) AS Missing_Vendors from dbo.Fact_PO_Transactions
LEFT JOIN dbo.Dim_Category ON dbo.Fact_PO_Transactions.Category_ID = dbo.Dim_Category.Category_ID
where dbo.Dim_Category.Category_ID IS NULL;

SELECT COUNT(*) AS Missing_Vendors from dbo.Fact_PO_Transactions
LEFT JOIN dbo.Dim_Department ON dbo.Fact_PO_Transactions.Department_ID = dbo.Dim_Department.Department_ID
where dbo.Dim_Department.Department_ID IS NULL;

SELECT COUNT(*) AS Missing_Vendors from dbo.Fact_PO_Transactions
LEFT JOIN dbo.Dim_PayStatus ON dbo.Fact_PO_Transactions.Status_ID = dbo.Dim_PayStatus.Status_ID
where dbo.Dim_PayStatus.Status_ID IS NULL;

SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT InvoiceNumber) AS UniqueInvoices,COUNT(DISTINCT PO_ID) AS UniquePOs
FROM Fact_PO_Transactions;

SELECT COUNT(*) AS Org_Rows,
SUM(CASE WHEN PO_ID LIKE '%-DUP' THEN 1 ELSE 0 END) AS Dup_Rows,
SUM(CASE WHEN PO_ID NOT LIKE '%-DUP' OR PO_ID IS NULL THEN 1 ELSE 0 END) AS Non_Dup_Rows
FROM dbo.Fact_PO_Transactions;

# CREATING VIEWS

CREATE VIEW vw_Fact_PO_Clean
AS
SELECT * FROM dbo.Fact_PO_Transactions
WHERE PO_ID NOT LIKE '%-DUP' OR PO_ID IS NULL;

SELECT COUNT(*) AS Total
FROM vw_Fact_PO_Clean;

# Vendor_Spend_View

CREATE VIEW vw_Vendor_Spend
AS 
Select Vendor_ID,VendorName_Raw,Count(*) AS Total_Transactions,SUM(PO_Amount) AS Total_PO_Amount,
SUM(InvoiceAmount) AS Total_Invoice_Amount, SUM(PaidAmount) AS Total_Paid_Amount,Avg(PO_Amount) AS Avg_PO_Amount
FROM vw_Fact_PO_Clean
group by Vendor_ID , VendorName_Raw; 

SELECT TOP 10 * FROM vw_Vendor_Spend;
Select * from vw_Vendor_Spend ORDER BY Total_Transactions DESC;

# Department_Spend

CREATE VIEW vw_Department_Spend
AS
SELECT Department_ID,COUNT(*) AS TotalTransactions,SUM(PO_Amount) AS TotalPOAmount,
SUM(InvoiceAmount) AS TotalInvoiceAmount,SUM(PaidAmount) AS TotalPaidAmount,AVG(PO_Amount) AS AvgPOAmount
FROM vw_Fact_PO_Clean
GROUP BY Department_ID;

DROP VIEW IF EXISTS vw_DepartmentSpend;
GO

CREATE VIEW vw_DepartmentSpend
AS
SELECT d.Department_ID, d.DepartmentName, d.Location, d.CostCenter,d.HeadName,d.AnnualBudget_INR,
COUNT(*) AS TotalTransactions,
SUM(f.PO_Amount) AS TotalPOAmount,
SUM(f.InvoiceAmount) AS TotalInvoiceAmount,
SUM(f.PaidAmount) AS TotalPaidAmount,
AVG(f.PO_Amount) AS AvgPOAmount
FROM vw_Fact_PO_Clean f
INNER JOIN Dim_Department d
    ON f.Department_ID = d.Department_ID
GROUP BY d.Department_ID, d.DepartmentName, d.Location,d.CostCenter,d.HeadName,d.AnnualBudget_INR;

Select * from vw_DepartmentSpend ORDER BY TotalPOAmount DESC;

Select Top 20 PaymentDueDate,ActualPaymentDate, PO_Status,PO_Amount from vw_Fact_PO_Clean;

# Payment_Health View

CREATE VIEW vw_PaymentHealth
AS
SELECT Transaction_ID,PO_ID,Vendor_ID,VendorName_Raw,InvoiceNumber,PO_Status,InvoiceAmount,PaidAmount,PaymentDueDate,ActualPaymentDate,
CASE WHEN ActualPaymentDate IS NULL THEN 'Outstanding'
WHEN ActualPaymentDate <= PaymentDueDate THEN 'On Time'
WHEN ActualPaymentDate > PaymentDueDate THEN 'Late'
END AS PaymentStatus,
CASE WHEN ActualPaymentDate IS NULL THEN NULL
ELSE DATEDIFF(DAY, PaymentDueDate, ActualPaymentDate)
END AS PaymentDelayDays
FROM vw_Fact_PO_Clean;

SELECT TOP 20 * FROM vw_PaymentHealth;

SELECT PaymentStatus,COUNT(*) AS Transactions
FROM vw_PaymentHealth
GROUP BY PaymentStatus;

Select VendorName_Raw , PaymentStatus from vw_PaymentHealth
WHERE PaymentStatus = 'Late';

SELECT
    COUNT(*) AS OutstandingInvoices,
    SUM(InvoiceAmount) AS OutstandingAmount
FROM vw_PaymentHealth
WHERE PaymentStatus = 'Outstanding';

SELECT ROUND(100.0 *SUM( CASE WHEN ActualPaymentDate > PaymentDueDate THEN 1 ELSE 0 END) / COUNT(*),2) AS LatePaymentPercentage
FROM vw_Fact_PO_Clean
WHERE ActualPaymentDate IS NOT NULL;

Select Avg(PaymentDelayDays) AS avg_delay from vw_PaymentHealth;

Select Sum(PaidAmount) AS Actual_Spent , Sum(ApprovedBudget) AS Budget from vw_Fact_PO_Clean;
Select Sum(PaidAmount) - Sum(ApprovedBudget) AS Difference from vw_Fact_PO_Clean;



















