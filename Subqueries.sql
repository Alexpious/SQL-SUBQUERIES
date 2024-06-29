
--Which date(s) had the highest total sales and which product(s) contributed to those sales?



select  date, product, total_sales
FROM TDIPROJECT.DBO.Salest
where total_sales = (SELECT max ( total_sales) as Maxtotalsales
FROM TDIPROJECT.DBO.Salest )

---Which product(s) had the highest average unit price among all products sold

SELECT Product, AVG(Unit_Price) AS AvgUnitPrice
FROM TDIPROJECT.DBO.Salest
GROUP BY Product
HAVING AVG(Unit_Price) = (
    SELECT MAX(AvgUnitPrice)
    FROM (
        SELECT AVG(Unit_Price) AS AvgUnitPrice
        FROM TDIPROJECT.DBO.Salest
        GROUP BY Product
    ) AS Subquery
);

---	What were the total sales for each product on dates where the quantity sold exceeded the average quantity sold for that product?


select s1. total_sales, s1. product , s1. date
FROM TDIPROJECT.DBO.Salest s1
where s1.quantity_sold >  (SELECT avg( s2.quantity_sold) as avgquantitysold
FROM TDIPROJECT.DBO.Salest  s2
where s2.product = s1.product)
order by s1.product, s1.date

--What were the top 3 dates with the highest total sales, and which product(s) contributed to those sales on each date?

SELECT TOP 3 DATE,  total_sales , product
FROM TDIPROJECT.DBO.Salest
order by total_sales desc


SELECT DATE, PRODUCT, TOTAL_SALES
FROM TDIPROJECT.DBO.Salest
WHERE DATE IN ( SELECT TOP 3 DATE
FROM TDIPROJECT.DBO.Salest
order by total_sales desc)
order by total_sales desc


SELECT Date, Product, SUM(Total_Sales) AS TotalSales
FROM TDIPROJECT.DBO.Salest
WHERE Date IN (
    SELECT TOP 3 Date
   FROM TDIPROJECT.DBO.Salest
    GROUP BY Date
    ORDER BY SUM(Total_Sales) DESC
)
GROUP BY Date, Product
ORDER BY Date, TotalSales DESC;

---What percentage of the total sales on April 15th, 2024, did each product contribute?

SELECT  Product,  Total_Sales, (Total_Sales / (SELECT SUM(Total_Sales) 
FROM TDIPROJECT.DBO.Salest 
WHERE Date = '2024-04-15') * 100) AS PercentageOfTotalSales
FROM TDIPROJECT.DBO.Salest
WHERE Date = '2024-04-15'


---Which product(s) had the highest total sales over any consecutive 3-day period?

SELECT TOP 1 Product, Date, ThreeDayTotal
FROM (
    SELECT 
        Product, 
        Date, 
        (SELECT SUM(Total_Sales)
         FROM TDIPROJECT.DBO.Salest S2
         WHERE S2.Product = S1.Product 
           AND S2.Date BETWEEN DATEADD(day, -2, S1.Date) AND S1.Date) AS ThreeDayTotal
    FROM TDIPROJECT.DBO.Salest S1
) AS Subquery
ORDER BY ThreeDayTotal DESC;



---On which date(s) did product C's total sales exceed the combined total sales of all other products?
SELECT Date
FROM TDIPROJECT.DBO.Salest S1
WHERE Product = 'C'
GROUP BY Date       
HAVING SUM(Total_Sales) > (
    SELECT SUM(Total_Sales)
    FROM TDIPROJECT.DBO.Salest S2
    WHERE S2.Date = S1.Date AND S2.Product != 'C'
)


---What were the cumulative total sales for each product over the entire period covered by the dataset, ordered by date?
SELECT Date, Product, Total_Sales,
 SUM(Total_Sales) OVER (PARTITION BY Product ORDER BY Date) AS Cumulative_Total_Sales
FROM TDIPROJECT.DBO.Salest
ORDER BY Product, Date;





