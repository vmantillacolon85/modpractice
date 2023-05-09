--1.For every track, list the name, the composer, and the track length (in milliseconds), 
--along with the average track length for that composer’s songs.



SELECT name, composer, milliseconds,
AVG(milliseconds) OVER (PARTITION BY composer)
FROM track t 
ORDER BY composer NULLS LAST



--2.List the customer lastname, the number of rentals, and the total number of rentals 
--from people who live in their city.

WITH customer_count AS
(
SELECT c.LastName, c.City, COUNT(il.InvoiceLineId) AS customer_total_rentals
FROM customer c
JOIN invoice i 
ON c.customerId = i.CustomerId 
JOIN InvoiceLine il 
ON i.InvoiceId = il.InvoiceId 
GROUP BY c.CustomerId 
)
SELECT LastName, customer_total_rentals,
SUM(customer_total_rentals) OVER (PARTITION BY customer_count.city) AS city_count
FROM customer_count