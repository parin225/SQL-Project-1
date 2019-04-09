USE sakila;

-- Dislay the first & last name of all actors from the actor table
SELECT first_name, last_name
FROM actor;

-- Display the first & last name of all actors in upper case letters in one column
SELECT UPPER(CONCAT (first_name,' ', last_name)) AS 'Actor Name' from actor;

-- Display a query to find the ID number, first & last name of an actor. Only information 
-- known is the first name, which is "Joe."
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

-- Display all actors whose last name contain the letters GEN
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- Display all actors whose last name contain the letters LI. 
-- Order the rows by last name and first name 
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- Display the country_id and country name columns for:
-- Afghanistan, Bangladesh and China
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- Create a column in the table actor, named description with the datatype BLOB
ALTER TABLE actor
ADD description BLOB;

-- Delete the description column just created 
ALTER TABLE actor
DROP COLUMN description;

-- Display the last names of the actors
-- Count how many actors have the same last name
SELECT last_name, COUNT(last_name) AS 'Number of Actors'
FROM actor
GROUP BY last_name;

-- Display the last names of actors that are shared by atleast 2 actors
SELECT last_name, COUNT(last_name) AS 'Number of Actors'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)  >= 2;

-- Replace 'Groucho Williams' in the actor table to 'Harpo Williams'
-- Set safe updates off
SET SQL_SAFE_UPDATES = 0;

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO';

-- Replace Harpo back to Groucho 
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO';

-- Set safe updates on
SET SQL_SAFE_UPDATES = 1;

-- Display a query to re-create the schema of the address table
SHOW CREATE TABLE address;

-- Display the first & last name, as well as the address of each staff member
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address
ON staff.address_id = address.address_id;

-- Display the total amount rung up by each staff member in August 2005
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS 'Total Payment'
FROM staff
INNER JOIN payment
ON staff.staff_id = payment.staff_id
WHERE payment_date LIKE '%2005-08%'
GROUP BY staff.staff_id;

-- Display each film & the number of actors listed for that film
SELECT film.title, COUNT(film_actor.actor_id) AS 'Number of Actors'
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.title;

-- Display the number of copies of the film Hunchback Impossible in the inventory system
SELECT title, film_id
FROM film
WHERE title = "Hunchback Impossible";

SELECT COUNT(inventory_id) AS 'Number of Copies'
FROM inventory
WHERE film_id = 439;

-- Display the total paid by each customer
-- Display the customers alphabetically by last name
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Paid'
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;

-- Display the titles of movies starting with letters K and Q whose language is English
SELECT title
FROM film
WHERE language_id IN
	(
		SELECT language_id
        FROM language 
        WHERE name = 'English' AND title LIKE 'K%' OR title LIKE 'Q%'
	);
	
-- Display all actors who appear in the film Alone Trip
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
		SELECT actor_id
		FROM film_actor
		WHERE film_id IN
        (
			SELECT film_id
            FROM film
            WHERE title = 'Alone Trip'
		)
	);

-- Display all the names & email addresses of all Canadian customers
SELECT first_name, last_name, email
FROM customer
INNER JOIN address ON address.address_id = customer.address_id 
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country on city.country_id = country.country_id
WHERE country = 'Canada';

-- Display all movies categorized as family films
SELECT title
FROM film
WHERE film_id IN
	(
		SELECT film_id
        FROM film_category
        WHERE category_id IN
        (
			SELECT category_id
            FROM category
            WHERE name = 'family'
		)
	);
    
-- Display the most frequently rented movies in descending order
SELECT title, count(title) AS 'Rental Movie Count'
FROM rental 
INNER JOIN inventory on rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY title
ORDER BY count(title) desc;

-- Write a query to display how much business, in dollars, each store bought in
-- Write a query to display each stores ID, city and country
SELECT store.store_id, city.city,country.country
FROM store
INNER JOIN address on store.address_id = address.address_id
INNER JOIN city on address.city_id = city.city_id
INNER JOIN country on city.country_id = country.country_id;

-- Display the top 5 genres in gross revenue in descending order
SELECT category.name, SUM(payment.amount) AS 'Gross Revenue'
FROM category
INNER JOIN film_category on category.category_id = film_category.category_id
INNER JOIN inventory on film_category.film_id = inventory.film_id
INNER JOIN rental on inventory.inventory_id = rental.inventory_id
INNER JOIN payment on rental.rental_id = payment.payment_id
GROUP BY category.name
ORDER BY SUM(payment.amount) desc
LIMIT 5;

-- Display an easier way to view the top 5 genres by gross revenue
-- Create a view using ^ above query
CREATE VIEW top_five_genres AS
SELECT category.name, SUM(payment.amount) AS 'Gross Revenue'
FROM category
INNER JOIN film_category on category.category_id = film_category.category_id
INNER JOIN inventory on film_category.film_id = inventory.film_id
INNER JOIN rental on inventory.inventory_id = rental.inventory_id
INNER JOIN payment on rental.rental_id = payment.payment_id
GROUP BY category.name
ORDER BY SUM(payment.amount) desc
LIMIT 5;

-- Display the view created ^ above
SELECT * FROM top_five_genres;

-- Write a query to delete the view created ^ above
DROP VIEW top_five_genres;


