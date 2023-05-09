select first_Name, last_name
from actor 
where last_name = 'Williams';

--

select Title, Description, Rating
from film 
where rating = 'PG' or rating = 'PG-13';

--

select country_id, country
from country
where country like 'G%'

--

select first_name, last_name, email
from customer
where last_name like '%son'

--

select customer_id, rental_id
from payment 
where amount > '10'


--

select first_name, last_name
from actor
where first_name in ('John','Mary', 'Ian', 'Dustin', 'Thora');
