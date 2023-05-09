--1. Using Invoice Table show average total per country

SELECT BillingCountry, ROUND(AVG(Total), 2) AS TotalPerCountry
FROM Invoice i 
GROUP BY BillingCountry
ORDER BY 2 DESC

-- 2. Create a table with the following columns InvoiceId, BillingCountry, Total, Avg_Total_for_Planet
-- for each InvoiceID

SELECT InvoiceID, BillingCountry, Total, 
AVG(Total) OVER() AS AvgTotalForPlanet
FROM Invoice i

SELECT InvoiceID, BillingCountry, Total, 
SUM(Total) OVER() AS SumTotalForPlanet
FROM Invoice i --this allows us to see the whole table and the rows

SELECT SUM(Total)
FROM Invoice i --this only shows one number on one row


WITH Country_Totals AS
(SELECT InvoiceID, BillingCountry, Total, 
SUM(Total) OVER() AS SumTotalForPlanet
FROM Invoice i)

SELECT *, ROUND((Total/SumTotalForPlanet) * 100, 2) PercentOfTotal
FROM Country_Totals
ORDER BY 5 DESC


---
-- 3. Create a table with the following columns InvoiceId, BillingCountry, Total, Avg_Total_for_Planet
-- for each InvoiceID
--STEPS

--Traditional Aggregate
SELECT InvoiceID, BillingCountry, Total,
SUM(Total)
FROM Invoice i
GROUP BY BillingCountry --this results in the code running one line per country not all the totals in the country


--Empty Bracket Window Function
SELECT InvoiceId, BillingCountry, Total,
SUM(Total) OVER() as TotalForWorld
FROM Invoice i 


--Window Function with Partition 
SELECT InvoiceId, BillingCountry, Total,
SUM(Total) OVER(PARTITION BY BillingCountry) as TotalPerCountry
FROM Invoice i  --this results in all the totals of the country
--ORDER BY 4 DESC


SELECT t.Composer, SUM(t.UnitPrice) 
FROM InvoiceLine il 
JOIN Track t 
ON il.TrackId = t.TrackId
GROUP BY t.Composer
ORDER BY 2 DESC


SELECT il.InvoiceId, t.Composer, t.UnitPrice,
SUM(t.UnitPrice) OVER()
FROM InvoiceLine il 
JOIN Track t 
ON il.TrackId = t.TrackId

SELECT il.InvoiceId, t.Composer, t.UnitPrice,
SUM(t.UnitPrice) OVER(PARTITION BY t.Composer)
FROM InvoiceLine il 
JOIN Track t 
ON il.TrackId = t.TrackId
WHERE t.Composer IS NOT NULL

SELECT il.InvoiceId, t.Composer, t.UnitPrice,
SUM(t.UnitPrice) OVER(PARTITION BY t.Composer) AS TotalPerArtist,
SUM(t.UnitPrice) OVER() as Total
FROM InvoiceLine il 
JOIN Track t 
ON il.TrackId = t.TrackId
WHERE t.Composer IS NOT NULL


------------------------------------------------------------------




---4. Create a table with the following columns InvoiceID, BillingCountry, 
--Total, Max_Total_per country,
--and the difference between total and max total

WITH cte AS 
( SELECT InvoiceId, BillingCountry, Total,
MAX(Total) OVER(PARTITION BY BillingCountry) AS MaxPerCountry
From Invoice i 
)

SELECT *, MaxPerCountry -Total
FROM cte 


--5.Create a table showing the BillingCountry and the Average difference from Average per country

WITH cte AS 
( SELECT InvoiceId, BillingCountry, Total,
Avg(Total) OVER(PARTITION BY BillingCountry) AS AvgPerCountry
From Invoice i 
)
,
cte2 AS
(
SELECT *, Total - AvgPerCountry AS Difference
FROM CTE
)
SELECT *,
AVG(Difference) OVER (PARTITION BY BillingCountry) AS AvgDifferencePerCountry
FROM cte2


--another solution: 

WITH cte AS
(
SELECT BillingCountry,Total,
AVG(Total) OVER (PARTITION BY BillingCountry) AS AvgPerCountry
FROM Invoice i
)
SELECT BillingCountry, AvgPerCountry, (AvgPerCountry - Total) AS Difference,
AVG(AvgPerCountry - Total) OVER (PARTITION BY BillingCountry)
FROM cte

--a solution to a similar but different question

WITH cte AS 
(
SELECT InvoiceId, BillingCountry, Total,
AVG(Total) OVER(PARTITION BY BillingCountry) AS AvgPerCountry,
AVG(Total) OVER() AS AvgForAllCountries -- this IS for ALL countries...
FROM Invoice i
)
SELECT *, AvgForAllCountries - AvgPerCountry AS AvgDifference
FROM cte

