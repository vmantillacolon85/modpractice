select * 
from customer
inner join	rental
on customer.customer_id = rental.customer_id 

--- make it more specific as below:

select customer.first_name , customer.last_name , rental.rental_date 
from customer
inner join	rental
on customer.customer_id = rental.customer_id 
--this tells me when everyone rented a movie

select customer.first_name , customer.last_name , rental.rental_date 
from customer
inner join	rental
on customer.customer_id = rental.customer_id 
order by customer.last_name --order by customer last_name
--
--this is our first extended join, using all inner joins

select customer.first_name , customer.last_name , rental.rental_date, film.title 
from customer
inner join	rental
on customer.customer_id = rental.customer_id 
inner join inventory 
on inventory.inventory_id = rental.inventory_id 
inner join film 
on inventory.film_id = film.film_id
order by customer.last_name


-- this below is how you can the aliases to cut down on the verbage above:

select c.first_name , c.last_name , r.rental_date
from rental r
join customer c 
on c.customer_id = r.customer_id 

--continuing to add inner joins using the aliases

select c.first_name , c.last_name , r.rental_date
from rental r
join customer c 
on c.customer_id = r.customer_id 
join inventory i 
on i.inventory_id = r.inventory_id 
join film f 
on i.film_id = f.film_id 
order by c.last_name 



---finding the actors that played in action movies only 

select  a.first_name, a.last_name, f.title, ca."name" 
from actor a 
join film_actor fa
on fa.actor_id = a.actor_id 
join film f 
on f.film_id = fa.film_id 
join film_category fc 
on f.film_id =fc.film_id 
join category ca 
on ca.category_id = fc.category_id 
order by f.title

--this shows all the film actors and movie types; we are looking for the actors in action movies only. we can do this below:

select  a.first_name, a.last_name, f.title, ca.name as category_name --the "as" changes the column of "name" to "category_name"
from actor a 
join film_actor fa
on fa.actor_id = a.actor_id 
join film f 
on f.film_id = fa.film_id 
join film_category fc 
on f.film_id =fc.film_id 
join category ca 
on ca.category_id = fc.category_id 
where ca.name = 'Action'
order by f.title
--this query above is looking for the actors in action movies
--

--can use an IN statement to look for action and family movies. 

select  a.first_name, a.last_name, f.title, ca.name as category_name --the "as" changes the column of "name" to "category_name"
from actor a 
join film_actor fa
on fa.actor_id = a.actor_id 
join film f 
on f.film_id = fa.film_id 
join film_category fc 
on f.film_id =fc.film_id 
join category ca 
on ca.category_id = fc.category_id 
where ca.name in ('Action', 'Family')
order by f.title

--can order by actor_id using the order by

select  a.first_name, a.last_name, f.title, ca.name as category_name 
from actor a 
join film_actor fa
on fa.actor_id = a.actor_id 
join film f 
on f.film_id = fa.film_id 
join film_category fc 
on f.film_id =fc.film_id 
join category ca 
on ca.category_id = fc.category_id 
where ca.name in ('Action', 'Family')
order by a.actor_id 

--adding an aggregate function like count to the query above


select a.first_name, a.last_name, Count(fa.film_id) as film_count
from actor a 
join film_actor fa 
on a.actor_id = fa.actor_id 
group by a.first_name, a.last_name 
order by film_count desc

--a list of actors who have appeared in forty films or more--

select a.first_name, a.last_name, Count(fa.film_id) as film_count
from actor a 
join film_actor fa 
on a.actor_id = fa.actor_id 
group by a.first_name, a.last_name
having count(fa.film_id) >= 40 --restricts to actors who have been in 40 or more films
order by film_count desc

-- top 10 actors by total number of films

select a.first_name, a.last_name, Count(fa.film_id) as film_count
from actor a 
join film_actor fa 
on a.actor_id = fa.actor_id 
group by a.first_name, a.last_name 
order by film_count desc --if you change "desc" to "asc" it will give you the bottom 10 
limit 10 --this will give me only the top 10

---finding films with their languages

select f.title, l.name
from film f
join language l
on l.language_id = f.language_id 

--find a count of how many films each language had?

select l.name, count(f.film_id)
from film f
join language l
on l.language_id = f.language_id 
group by l.language_id 
--this is only giving me english language films count
--however we want all the languages

select l.name, count(f.film_id)
from "language" l 
left join film f 
on l.language_id  = f.language_id 
group by l.name

--this shows all the film languages count

select l.name, count(f.film_id)
from film f
right join "language" l 
on l.language_id  = f.language_id 
group by l.name

----- full outer join 


select *
from actor a 
full outer join film_actor fa 
on a.actor_id = fa.actor_id

--find out actors who have never been in any films

select a.first_name, a.last_name, count(fa.film_id)
from actor a 
full outer join film_actor fa 
on a.actor_id = fa.actor_id
group by  a.first_name , a.last_name 
having count(fa.film_id) = 0

--languages that have no films

select l.name, count(f.film_id)
from film f 
full outer join "language" l  
on l.language_id = f.language_id 
group by  l.name
having count(f.film_id) = 0

--most rented film title in the inventory

select f.title, count(f.film_id)
from film f 
left join inventory i 
on f.film_id = i.film_id 
left join rental r
on r.inventory_id = i.inventory_id 
group by f.title 
order by count(f.film_id) desc


---list customer and total amount spent from most to least






--list the film categories in order most to least popular and count the total number of rentals for each 

select c."name", count(r.rental_id) as most_rentals
from category c 
join film_category fc 
on c.category_id = fc.category_id 
join film f 
on f.film_id= fc.film_id
join inventory i 
on i.film_id=f.film_id
join rental r 
on r.inventory_id = i.inventory_id 
group by c."name"
order by most_rentals desc

--with fewer join tables

select c."name", count(r.rental_id) as most_rentals
from category c 
join film_category fc 
on c.category_id = fc.category_id 
join film f 
on f.film_id= fc.film_id
join inventory i 
on i.film_id=f.film_id
join rental r 
on r.inventory_id = i.inventory_id 
group by c."name"
order by most_rentals desc


---list film titles without any inventory

select f.title,count(i.inventory_id) as amount_inventory
from film f 
left join inventory i 
on f.film_id = i.film_id 
group by f.title 
having count(i.inventory_id) = 0
order by f.title 

--this is with an inner join
select f.title,count(i.inventory_id) as amount_inventory
from film f 
join inventory i 
on f.film_id = i.film_id 
group by f.title 
--having count(i.inventory_id) = 0
order by f.title 
























