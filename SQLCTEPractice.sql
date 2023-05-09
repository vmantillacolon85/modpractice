-- what is the total $ spent by gmail users in each city? 
SELECT i.BillingCity, sum(i.Total)
FROM Invoice i 
JOIN Customer c ON c.CustomerId = i.CustomerId 
WHERE c.Email LIKE "%gmail%"
GROUP BY i.BillingCity
--
-- what is total $ spent in cities where at least one person uses gmail? 
SELECT i.BillingCity, sum(i.Total)
FROM invoice i
WHERE i.BillingCity IN(
SELECT DISTINCT City  FROM Customer c2  -- this subquery gives us a list OF cities
WHERE Email LIKE "%gmail%" )
GROUP BY BillingCity;
-- 
​
​
-- what is the average number of tracks on an album for each genre? 
SELECT o.Name, avg(o.track_count)
FROM 
(SELECT g.name, a.title, count(t.TrackId) AS track_count
FROM Album a 
JOIN track t ON t.AlbumId = a.AlbumId 
JOIN Genre g ON g.GenreId = t.GenreId 
GROUP BY a.title) AS o 
GROUP BY o.Name
--
​
--What city has spent the most money at our store? 
SELECT BillingCity, sum(Total)
FROM invoice 
GROUP BY BillingCity
ORDER BY sum(Total) DESC 
LIMIT 1
-- not bad, but assumes there will be no tie for 1st place
--
SELECT BillingCity, max(Total)
FROM (SELECT BillingCity, sum(Total) AS total
FROM invoice 
GROUP BY BillingCity
)
-- Good, but still doesn't work for a tie-for-most-money spent
​
SELECT BillingCity, Total 
FROM (SELECT BillingCity, sum(Total) AS total
FROM invoice 
GROUP BY BillingCity
ORDER BY sum(Total) DESC
)
WHERE total = 
(SELECT max(total) FROM (SELECT sum(total) AS total 
 FROM invoice GROUP BY BillingCity))
​
-- aha!  Wait. This is getting confusing. 


--
--What city has spent the most money at our store? 
​
SELECT BillingCity, Total 
FROM (SELECT BillingCity, sum(Total) AS total
FROM invoice 
GROUP BY BillingCity
ORDER BY sum(Total) DESC
)
WHERE total =  
(SELECT max(total) FROM (SELECT sum(total) AS total 
 FROM invoice GROUP BY BillingCity))
-- aha!  Wait. This is getting confusing. 
​
 -- let's use a CTE instead of subqueries
WITH total_by_city AS (
SELECT BillingCity, sum(Total) AS total
FROM invoice 
GROUP BY BillingCity
ORDER BY sum(Total) DESC
)
SELECT  BillingCity, total
FROM total_by_city
WHERE total=(SELECT max(total) FROM total_by_city)
​
---
​
-- what is the average number of tracks on an album for each genre? 
WITH track_count_albums AS (
SELECT g.name, a.title, count(t.TrackId) AS track_count
FROM Album a 
JOIN track t ON t.AlbumId = a.AlbumId 
JOIN Genre g ON g.GenreId = t.GenreId 
GROUP BY a.title
)
SELECT name, avg(track_count) 
FROM track_count_albums
GROUP BY name



---- What's the largest amount of money spent by an individual for each city in our database?
--Return City, Person, Total $ Spent

--One solution:

WITH moneys_spent_cte AS (
SELECT c.FirstName, c.LastName, c.City, SUM(i.total) AS by_city_total_spend
FROM Customer c JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY i.CustomerId
ORDER BY by_city_total_spend DESC)
SELECT FirstName, LastName, city, MAX(by_city_total_spend)
FROM moneys_spent_cte
GROUP BY City
ORDER BY by_city_total_spend DESC


---Another solution

WITH customer_total AS (
SELECT c.LastName, c.City, SUM(i.total) AS total_purchases
FROM Customer c 
JOIN Invoice i 
ON c.CustomerId = i.CustomerId 
GROUP BY i.CustomerId 
ORDER BY total_purchases DESC 
)
SELECT city, lastname, MAX(total_purchases)
FROM customer_total
GROUP by City 
ORDER BY total_purchases DESC


--what artist in each genre has the most albums?


WITH album_count AS (
SELECT g.Name AS Genre, ar.ArtistID, ar.Name AS Artist_name, 
COUNT(al.AlbumId) AS num_albums
FROM Artist ar
Join Album al 
	ON ar.ArtistId = al.ArtistId
JOIN Track t
	ON t.AlbumId = al.AlbumId 
JOIN Genre g 
	ON g.GenreId = t.GenreId 
GROUP BY ar.Name
)

SELECT Artist_name, Genre, MAX(num_albums) 
FROM album_count
GROUP BY Genre
ORDER BY MAX(num_albums) DESC




--what is the genre with the longest average track length?

