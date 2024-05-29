-- 1. Determine the number of copies of the film "Hunchback Impossible" in the inventory system
SELECT 
    COUNT(i.inventory_id) AS number_of_copies
FROM 
    sakila.film f
JOIN 
    sakila.inventory i ON f.film_id = i.film_id
WHERE 
    f.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database
SELECT 
    title, 
    length
FROM 
    sakila.film
WHERE 
    length > (SELECT AVG(length) FROM sakila.film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip"
SELECT 
    a.first_name, 
    a.last_name
FROM 
    sakila.actor a
JOIN 
    sakila.film_actor fa ON a.actor_id = fa.actor_id
WHERE 
    fa.film_id = (SELECT film_id FROM sakila.film WHERE title = 'Alone Trip');
    
    -- Bonus
    -- 4. Identify all movies categorized as family films
SELECT 
    f.title
FROM 
    sakila.film f
JOIN 
    sakila.film_category fc ON f.film_id = fc.film_id
JOIN 
    sakila.category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family';

-- 5. Retrieve the name and email of customers from Canada using subqueries
SELECT 
    first_name, 
    last_name, 
    email
FROM 
    sakila.customer
WHERE 
    address_id IN (
        SELECT address_id 
        FROM sakila.address 
        WHERE city_id IN (
            SELECT city_id 
            FROM sakila.city 
            WHERE country_id = (
                SELECT country_id 
                FROM sakila.country 
                WHERE country = 'Canada'
            )
        )
    );

-- 5. Retrieve the name and email of customers from Canada using joins
SELECT 
    c.first_name, 
    c.last_name, 
    c.email
FROM 
    sakila.customer c
JOIN 
    sakila.address a ON c.address_id = a.address_id
JOIN 
    sakila.city ci ON a.city_id = ci.city_id
JOIN 
    sakila.country co ON ci.country_id = co.country_id
WHERE 
    co.country = 'Canada';

-- 6. Determine which films were starred by the most prolific actor
SELECT 
    f.title
FROM 
    sakila.film f
JOIN 
    sakila.film_actor fa ON f.film_id = fa.film_id
WHERE 
    fa.actor_id = (SELECT fa.actor_id 
                   FROM sakila.film_actor fa 
                   GROUP BY fa.actor_id 
                   ORDER BY COUNT(fa.film_id) DESC 
                   LIMIT 1);

-- 7. Find the films rented by the most profitable customer
SELECT 
    f.title
FROM 
    sakila.film f
JOIN 
    sakila.inventory i ON f.film_id = i.film_id
JOIN 
    sakila.rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.customer_id = (SELECT p.customer_id 
                     FROM sakila.payment p 
                     GROUP BY p.customer_id 
                     ORDER BY SUM(p.amount) DESC 
                     LIMIT 1);
                     -- 8. Retrieve the client ID and total amount spent of those clients who spent more than the average of the total amount spent by each client
                     SELECT 
    customer_id, 
    total_amount_spent
FROM (
    SELECT 
        p.customer_id, 
        SUM(p.amount) AS total_amount_spent
    FROM 
        sakila.payment p
    GROUP BY 
        p.customer_id
) subquery
WHERE 
    total_amount_spent > (SELECT AVG(total_amount_spent)
                          FROM (
                              SELECT 
                                  SUM(p.amount) AS total_amount_spent
                              FROM 
                                  sakila.payment p
                              GROUP BY 
                                  p.customer_id
                          ) avg_subquery);
