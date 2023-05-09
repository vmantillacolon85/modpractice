-- SUBQUERIES and CTEs
/* To understand the value of a subquery we must first understand
 * the output of the out puts of our queries.*/
-- 0. Which films have never been rented?
-- 1. All movies with the actors whose names start with A

select *
from film f 
where film_id in (
select distinct (film_id)
from actor as A
join film_actor as fa 
on a.actor_id = fa.actor_id 
where first_name like 'A%'
)




-- 1.1. What is the average rental rate per rental in our video store?

select ROUND(AVG(f2.rental_rate), 2)
from rental r 
join inventory i 
on r.inventory_id = i.inventory_id
join film f2
on i.film_id = f2.film_id 

-- 1.2. Actors whose first names start with A

select *
from actor 
where first_name like 'A%' --this outputs a table



-- 1.3. IDs of actors whose first names start with A


select actor_id 
from actor 
where first_name like 'A%' --this outputs a list
-- 1.4. All movies with the actors whose names start with A

select *
from film_actor fa 
where fa.actor_id in (select actor_id 
					  from actor 
					  where first_name like 'A%') --used a list inside of () and 
					  --then made another table via the outer select statement

-- 2. What films have an above average rental rate?
					  
select title, rental_rate
from film 
where rental_rate > (
					 select ROUND(AVG(f2.rental_rate), 2)
					 from rental r 
					 join inventory i 
					 on r.inventory_id = i.inventory_id 
					 join film f2
					 on i.film_id = f2.film_id )
					  
					  
-- 3.3 Which actors play in our top 10 most rented films?
					 
with rentals_and_films AS
(
select r.rental_id, r.inventory_id, i.film_id, f.title
from rental r
left join inventory i
on r.inventory_id = i.inventory_id 
left join film f 
on i.film_id = f.film_id 
),
top_ten_films AS
(select film_id, title, COUNT(*)
from rentals_and_films	
group by film_id, title
order by 3
limit 10
)
select distinct (concat(first_name, ' ', last_name)) as actor_name, COUNT(top_ten_films)
from actor a
join film_actor	fa 
on a.actor_id = fa.actor_id 
join top_ten_films
on fa.film_id = top_ten_films.film_id
group by 1
order by 2 desc 

					 


