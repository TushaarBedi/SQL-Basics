use sakila; -- Use Sakila Database

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Display the first and last names of all actors from the table actor*/
select actor.first_name, actor.last_name
from actor;

/* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. */
SELECT A.first_name, A.last_name, CONCAT(A.first_name, ' ', A.last_name) AS 'Actor Name'
FROM actor A;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?*/
select actor.actor_id, actor.first_name, actor.last_name
from actor where actor.first_name = "JOE";

/* 2b. Find all actors whose last name contain the letters GEN */
select a.first_name, a.last_name
from actor a where a.last_name LIKE "%GEN%";

/* 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order */
select a.last_name, a.first_name
from actor a where a.last_name LIKE "%LI%"
order by a.last_name;

/* 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China */
select c.country_id, c.country from country c
where country IN ('Afghanistan', 'Bangladesh', 'China');

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type */
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `middle_name` VARCHAR(45) NOT NULL AFTER `first_name`;

/*3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs */
ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` BLOB NOT NULL ;

/*3c. Now delete the middle_name column */
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `middle_name`;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* 4a. List the last names of actors, as well as how many actors have that last name. */
SELECT  a.last_name, COUNT(*) FROM actor a GROUP BY a.last_name;

/*
Complete SELECT query
SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
FROM mytable
    JOIN another_table
      ON mytable.column = another_table.column
    WHERE constraint_expression
    GROUP BY column
    HAVING constraint_expression
    ORDER BY column ASC/DESC
    LIMIT count OFFSET COUNT;
*/

/*4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors */
SELECT  a.last_name, count(a.last_name) as last_count
from actor a group by a.last_name
having last_count >=2;

/* 4c. Oh, no! The actor Harpo WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.*/

update actor a
set a.first_name = 'Harpo'
where a.first_name LIKE 'Groucho' and a.last_name like 'Williams';

-- Verifying the name update took place properly....
select a.actor_id, a.first_name, a.last_name from actor a
where a.first_name like 'Harpo';
-- Got the actor ID as 172

/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)*/

update actor a
set a.first_name = 'GROUCHO'
WHERE a.first_name LIKE 'Harpo' and a.actor_id = 172;




-- Verifying the name update took place properly....
select a.actor_id, a.first_name, a.last_name from actor a
where a.first_name like 'GROUCHO';

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*5a. You cannot locate the schema of the address table. Which query would you use to re-create it? */
describe address;

-- Command to show the schema SQL query for the table
show create table address;

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*
Complete SELECT query
SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
FROM mytable
    JOIN another_table
      ON mytable.column = another_table.column
    WHERE constraint_expression
    GROUP BY column
    HAVING constraint_expression
    ORDER BY column ASC/DESC
    LIMIT count OFFSET COUNT;
*/



/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address */

select * from staff;
select * from address;

/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address */

select staff.first_name, staff.last_name, address.address, address.district, address.postal_code, address.phone
from staff
join address 
ON staff.address_id = address.address_id;

/* 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. */

select * from sakila.staff;
select * from sakila.payment;

select staff.first_name, staff.last_name,  sum(payment.amount) as total_amount
from staff 
join payment on staff.staff_id = payment.staff_id
where payment.payment_date like '2005-08%'
group by staff.first_name, staff.last_name;

/* 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join. */
select * from film_actor;
select * from film;

select sakila.film.title, count(sakila.film_actor.actor_id)
from sakila.film
join sakila.film_actor on sakila.film.film_id = sakila.film_actor.film_id
group by sakila.film.title;

/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/

select count(inventory.film_id)  as Hunchback_Impossible_Count
from inventory
where inventory.film_id IN
(
select film_id from film
where title LIKE "Hunchback Impossible"
);

/* 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name: */

select * from payment;
select * from customer;

select customer.last_name, customer.first_name, sum(payment.amount)
from customer 
inner join payment on customer.customer_id = payment.customer_id
group by customer.last_name, customer.first_name;


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*
Complete SELECT query
SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
FROM mytable
    JOIN another_table
      ON mytable.column = another_table.column
    WHERE constraint_expression
    GROUP BY column
    HAVING constraint_expression
    ORDER BY column ASC/DESC
    LIMIT count OFFSET COUNT;
*/




/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies
starting with the letters K and Q whose language is English. */


select * from film where film.title LIKE "K%" or film.title LIKE "Q%" and film.language_id in 
(
select language_id from language where language.name LIKE "English"
);

/* 7b. Use subqueries to display all actors who appear in the film Alone Trip. */

select * from film;
select * from film_actor;
select * from actor;

select actor.first_name, actor.last_name
from actor 
where actor.actor_id IN
(
select film_actor.actor_id from film_actor where film_actor.film_id IN
(select film.film_id from film where film.title LIKE  "Alone Trip"
)
);


/*7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.*/
select * from country;
select * from customer;
select * from address;
select * from city;


select customer.first_name, customer.last_name, customer.email from
customer
where customer.address_id in 
(
select address.address_id from address
where address.city_id in 
(
select city.city_id from city
where city.country_id in
(
select country.country_id from country
where country LIKE "Canada"
)
)
);

/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.*/

select * from film; -- returns film_id and title
select * from film_category; -- Returns film_id and category_id
select * from category;


select film.title, film.description from film
where film_id in
(
select film_category.film_id from film_category
where film_category.category_id in
(
select category.category_id from category
where category.name LIKE "Family"
)
);

# Additional query for getting the count of films....

select count(film.title) from film
where film_id in
(
select film_category.film_id from film_category
where film_category.category_id in
(
select category.category_id from category
where category.name LIKE "Family"
)
);

/* 7e. Display the most frequently rented movies in descending order. */

select * from rental; -- rental_id and inventory_id
select * from inventory; -- inventory_id and film_id
select * from film; -- film_id and title, description


select film.title, count(film.title) as film_count
from film,inventory, rental
where film.film_id = inventory.film_id and inventory.inventory_id = rental.inventory_id
group by 1 order by film_count desc;


/* 7f. Write a query to display how much business, in dollars, each store brought in. */

/*
select * from store; -- returns store_id, staff_id
select * from payment;
select * from staff;

select store.store_id, sum(payment.amount) as total_amount from
store 
join payment
on store.manager_staff_id = payment.staff_id
group by 1;
*/

/* 7f. Write a query to display how much business, in dollars, each store brought in. */

select * from store;
select * from inventory;
select * from rental;
select * from payment;

select store.store_id, sum(payment.amount) as total_amount from
store, payment, staff
where store.store_id = staff.store_id and staff.staff_id = payment.staff_id
group by 1;

select * from payment where rental_id is NULL;

-- 7g. Write a query to display for each store its store ID, city, and country.

select * from store; -- returns store_id and address_id
select * from address; -- returns city_id
select * from city; -- returns city and country_id
select * from country; -- returns country name

select store.store_id, city.city, country.country from
store, address, city, country
where 
store.address_id = address.address_id and address.city_id = city.city_id and city.country_id = country.country_id;


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
use sakila;
select * from category;
select * from film_category;
select * from inventory;
select * from payment;
select * from rental;

select category.name, sum(payment.amount) as gross_revenue from
payment, rental, inventory, film_category, category
where
payment.rental_id = rental.rental_id and rental.inventory_id = inventory.inventory_id and inventory.film_id = film_category.film_id and film_category.category_id = category.category_id
group by 1 order by gross_revenue desc limit 5;





/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*
Complete SELECT query
SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
FROM mytable
    JOIN another_table
      ON mytable.column = another_table.column
    WHERE constraint_expression
    GROUP BY column
    HAVING constraint_expression
    ORDER BY column ASC/DESC
    LIMIT count OFFSET COUNT;
*/


/*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
8b. How would you display the view that you created in 8a?
8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

*/




-- /*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create view  top_gross_revenue_generes as
(
select category.name, sum(payment.amount) as gross_revenue from
payment, rental, inventory, film_category, category
where
payment.rental_id = rental.rental_id and rental.inventory_id = inventory.inventory_id and inventory.film_id = film_category.film_id and film_category.category_id = category.category_id
group by 1 order by gross_revenue
);

-- 8b. How would you display the view that you created in 8a, Display the view

select * from top_gross_revenue_generes order by gross_revenue desc limit 5;


-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW `sakila`.`top_gross_revenue_generes`;

