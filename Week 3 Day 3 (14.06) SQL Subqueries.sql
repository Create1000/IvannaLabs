USE sakila;
#1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(inventory_id) AS count_inventory_id
FROM inventory
WHERE film_id in (SELECT film_id
                  FROM film 
                  Where title = 'Hunchback Impossible');
                  
#2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT film_id, title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

#3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN (
    SELECT film_id
    FROM film
    WHERE title = 'Alone Trip'
  )
);

#4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN (SELECT film_id
                     FROM film_category
                     WHERE category_id IN (SELECT category_id
                                       FROM category
                                       WHERE name = 'family'));

#5.Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN (
  SELECT customer_id
  FROM address
  WHERE city_id IN (
    SELECT city_id
    FROM city
    WHERE country_id = (
      SELECT country_id
      FROM country
      WHERE country = 'Canada'
    )
  )
);

SELECT first_name, email
from customer
where address_id in (SELECT address_id
					 from address
                     join city on city.city_id = address.city_id
					 join country on country.country_id = city.country_id
					 where country = "canada");
                     
#6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
#the most prolific actor
SELECT a.actor_id, a.first_name, a.last_name, COUNT(*) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;

#film list form with the most prolific actor
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN (
  SELECT a.actor_id, COUNT(fa.film_id) AS film_count
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  GROUP BY a.actor_id
  ORDER BY film_count DESC
  LIMIT 1
) AS most_prolific_actor ON fa.actor_id = most_prolific_actor.actor_id;

#7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN (
  SELECT c.customer_id, SUM(p.amount) AS total_payment
  FROM customer c
  JOIN payment p ON c.customer_id = p.customer_id
  GROUP BY c.customer_id
  ORDER BY total_payment DESC
  LIMIT 1
) AS most_profitable_customer ON r.customer_id = most_profitable_customer.customer_id;

#8.Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_amount_spent
FROM Customer c
JOIN Rental r ON c.customer_id = r.customer_id
JOIN Payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT c.customer_id, SUM(p.amount) AS total_amount
        FROM Customer c
        JOIN Rental r ON c.customer_id = r.customer_id
        JOIN Payment p ON r.rental_id = p.rental_id
        GROUP BY c.customer_id
    ) AS subquery
);