--Write a query that returns artist name and track name for tracks between 5 and 10 minutes

SELECT a.name, a2.title, t.name, t.Milliseconds as minutes
from Artist a
join Album a2
on	a.ArtistId = a2.ArtistId
join Track t 
on t.AlbumId = a2.AlbumId
where t.Milliseconds/1000/60 between 5 and 10

--Write a query that returns customer Firstname and Lastname, and Track name for invoices between April 1 and April 30.

SELECT c.FirstName, c.LastName, t.name
from Customer c
join Invoice i
on c.CustomerId = i.CustomerId
join InvoiceLine il
on il.InvoiceId = i.InvoiceId
join Track t
on t.TrackId = il.TrackId
where i.InvoiceDate BETWEEN '2007-04-01' and '2007-04-30'

--Write a query that returns track names and total purchase $ for customers who live in Prague

SELECT t.name, c.city, SUM(i.total) as Total
FROM Customer c
join Invoice i
on c.CustomerId = i.CustomerId
join InvoiceLine il
on il.InvoiceId = i.InvoiceId
join Track t
on t.TrackId = il.TrackId
where c.city = 'Prague'
group by t.Name
order by SUM(i.total) DESC


--Write a query that returns all the customers (firstname, lastname) who purchased tracks of type 'Heavy Metal'

SELECT Distinct c.FirstName, c.LastName
FROM Customer c
join Invoice i
on c.CustomerId = i.CustomerId
join InvoiceLine il
on il.InvoiceId = i.InvoiceId
join Track t
on t.TrackId = il.TrackId
join Genre g
on t.GenreId = g.GenreId
where g.name = 'Heavy Metal'

--Write a query that lists the customers (firstname, lastname) and a count of their invoices, listed from most to least invoices

SELECT c.FirstName, c.LastName, COUNT(i.InvoiceId) as NumberofInvoices
FROM Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName
ORDER BY COUNT(i.InvoiceId) DESC

--Write a query that lists the top 10 artists (name) who have appeared on the most albums from most to least.

SELECT a.Name, COUNT(a2.AlbumId)
FROM Artist a
join Album a2
on a.ArtistId = a2.ArtistId
ORDER BY COUNT(a2.AlbumId)  DESC
LIMIT 10

--Write a query that lists the top 5 tracks by total invoice $

SELECT t.Name, SUM(i.Total) as InvoiceTotal
FROM Track t
JOIN InvoiceLine il
ON il.TrackId = t.TrackId
JOIN Invoice i
ON i.InvoiceId = il.InvoiceId
GROUP BY t.Name
ORDER BY SUM(i.Total) DESC
LIMIT 5

--Write a query that lists the composers, their track names, and the albums who have written the most tracks

SELECT t.Composer, t.Name, COUNT(t.AlbumId) AS NumberOfTracks
FROM Album a
JOIN Track t
ON t.AlbumId = a.AlbumId
GROUP BY t.Name
ORDER BY COUNT(t.AlbumId) DESC
