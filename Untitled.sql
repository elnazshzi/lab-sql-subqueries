use sakila;



-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

select f.title, count(i.inventory_id) as exict_movie
from sakila.film f
join sakila.inventory i using(film_id)
where f.title = 'Hunchback Impossible';


-- 2. List all films whose length is longer than the average of all the films.

select title, length
from sakila.film 
where length > (select avg(length) from sakila.film);


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

select a.first_name, last_name
from sakila.actor a  
where actor_id in (
      select actor_id
      from sakila.film_actor
      where film_id in ( select film_id from sakila.film where title = 'Alone Trip' )
      );


-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

select title as family_movies 
from sakila.film 
where film_id in (
    select film_id
    from sakila.film_category
    join category using(category_id)
    where category.name = 'family'
    );


-- 5. Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify 
-- the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

select c.first_name,last_name,email
from sakila.customer c
join sakila.address a using(address_id)
join sakila.city ci using (city_id)
join sakila.country co using(country_id)
where co.country = 'Canada';

-- or

select c.first_name,last_name,email
from sakila.customer c
where address_id in (
      select address_id
      from address
      join city using(city_id)
      join country using (country_id)
      where country= 'Canada'
      );

-- or

select c.first_name,last_name,email
from sakila.customer c
where address_id in (
      select address_id
      from address
      where city_id in(
          select city_id
          from sakila.city
          where country_id in ( select country_id from sakila.country where country= 'Canada'))
);
     
     
-- 6. Which are films starred by the most prolific actor?
-- Most prolific actor is defined as the actor that has acted in the most number of films.
      
      
 select  actor_id, count(*) as total_movies
 from film_actor
 group by actor_id
 order by total_movies desc
 limit 1;
      
      
 select f.title 
 from sakila.film f 
join sakila.film_actor fa using(film_id)
where fa.actor_id = (
   select actor_id 
   from(
     select  fa.actor_id,  count(*) as total_movies
     from sakila.film_actor
     group by fa.actor_id
     order by total_movies desc
     limit 1   
     ) as most_prolific_actor
);
    
    
-- 7. Films rented by most profitable customer.

SELECT f.title
FROM sakila.film f
JOIN sakila.inventory i ON f.film_id = i.film_id
JOIN sakila.rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (
    SELECT customer_id
    FROM sakila.payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);
         
         
-- 8. Get the client_id and the total_amount_spent of those clients who spent 
-- more than the average of the total_amount spent by each client.
  


 
      
