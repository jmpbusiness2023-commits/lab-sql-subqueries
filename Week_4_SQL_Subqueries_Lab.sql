-- SQL Subqueries Lab --

-- 1. Number of copies of the film "Hunchback Impossible" that exist in the inventory system
SELECT COUNT(*) AS number_of_copies
FROM inventory
WHERE film_id = (SELECT film_id
                 FROM film
                 WHERE title = 'Hunchback Impossible');

-- 2. All films whose length is longer than the average length of all the films
SELECT f.title,
       f.length
FROM film f
WHERE f.length > (SELECT AVG(length)
                  FROM film);

-- 3. All actors who appear in the film "Alone Trip"
SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor_full_name
FROM actor a
WHERE a.actor_id IN (SELECT fa.actor_id
                     FROM film_actor fa
                     WHERE fa.film_id = (SELECT f.film_id
                                         FROM film f
                                         WHERE f.title = 'Alone Trip'));

-- BONUS --
-- 4. All movies categorized as family films
SELECT f.title
FROM film f
WHERE f.film_id IN (SELECT fc.film_id
                    FROM film_category fc
                    WHERE fc.category_id = (SELECT c.category_id
                                           FROM category c
                                           WHERE c.name = 'Family'));

-- 5. Name and email of customers from Canada
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
       c.email
FROM customer c
WHERE c.address_id IN (SELECT a.address_id
                       FROM address a
                       LEFT JOIN city ci ON a.city_id = ci.city_id
                       LEFT JOIN country co ON ci.country_id = co.country_id
                       WHERE co.country = 'Canada');

-- 6. Films were starred by the most prolific actor
SELECT f.title
FROM film f
WHERE f.film_id IN (SELECT fa.film_id
                    FROM film_actor fa
                    WHERE fa.actor_id = (SELECT fa.actor_id
                                         FROM film_actor fa
                                         GROUP BY fa.actor_id
                                         ORDER BY COUNT(*) DESC
                                         LIMIT 1));

-- 7. The films rented by the most profitable customer
SELECT f.title
FROM film f
WHERE f.film_id IN (SELECT i.film_id
                    FROM inventory i
                    WHERE i.inventory_id IN (SELECT r.inventory_id
                                             FROM rental r
                                             WHERE r.customer_id = (SELECT p.customer_id
                                                                    FROM payment p
                                                                    GROUP BY p.customer_id
                                                                    ORDER BY SUM(p.amount) DESC
                                                                    LIMIT 1)));

-- 8. Client_id and total_amount_spent of those clients who spent more than the average of the total_amount spent by each client
SELECT p.customer_id,
       SUM(p.amount) AS total_amount_spent
FROM payment p
GROUP BY p.customer_id
HAVING total_amount_spent > (SELECT AVG(total_amount_spent)
                              FROM (SELECT SUM(p.amount) AS total_amount_spent
                                    FROM payment p
                                    GROUP BY p.customer_id) AS subquery);