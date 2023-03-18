USE sakila;

###Instructions
### 1.Write a query to display for each store its store ID, city, and country.

CREATE TEMPORARY TABLE sakila.store_info
SELECT A.store_id, B.address, C.city, D.country
FROM store as A
INNER JOIN address as B
USING (address_id)
INNER JOIN city as C
USING (city_id)
INNER JOIN country as D
USING (country_id)
GROUP BY A.store_id;


### B.address2 only contains null values, hence was dropped from the query

CREATE TEMPORARY TABLE no_cards_2
SELECT c1.client_id, COUNT(card_id) as num_cards
FROM client c1
LEFT JOIN disp d
USING (client_id)
LEFT JOIN card c2
USING (disp_id)
GROUP BY c1.client_id
HAVING num_cards = 0;


### 2.Write a query to display how much business, in dollars, each store brought in.

SELECT A.store_id, CONCAT('$', SUM( B.amount)) AS total_amount
FROM staff as A
INNER JOIN  payment as B
On A.staff_id = B.staff_id
GROUP BY A.store_id;


### 3.What is the average running time of films by category?

SELECT B.category_id,C.name, SEC_TO_TIME(AVG(length*60)) as average_length
FROM film as A
INNER JOIN film_category as B
USING (film_id)
INNER JOIN category as C
USING (category_id)
GROUP BY B.category_id;


### 4.Which film categories are longest?

SELECT B.category_id,C.name, SEC_TO_TIME(AVG(length*60)) as average_length
FROM film as A
INNER JOIN film_category as B
USING (film_id)
INNER JOIN category as C
USING (category_id)
GROUP BY B.category_id
ORDER BY average_length DESC;

### 5.Display the most frequently rented movies in descending order.
 
 SELECT * FROM RENTAL
 LIMIT 5;
 
 
SELECT F.title, COUNT(R.rental_id) AS rental_count
FROM rental AS R
JOIN inventory AS I 
ON R.inventory_id = I.inventory_id
JOIN film AS F 
ON I.film_id = F.film_id
GROUP BY F.title
ORDER BY rental_count DESC;

### 6.List the top five genres in gross revenue in descending order.

### Temporary table created for reference and cross checking

CREATE TEMPORARY TABLE sakila.gross_rev
SELECT A.name, B.category_id, C.rental_rate, D.film_id, E.rental_id, CONCAT('$', SUM( F.amount)) AS rental_money
FROM category AS A
JOIN film_category as B
ON A.category_id=B.category_id
JOIN film as C
ON B.film_id=C.film_id
JOIN inventory as D
ON C.film_id= D.film_id
JOIN rental as E
ON D.inventory_id= E.inventory_id
JOIN payment as F
ON E.rental_id= F.rental_id
GROUP BY A.name, B.category_id, C.rental_rate, D.film_id, E.rental_id;

SELECT * FROM gross_rev
LIMIT 5;

SELECT name as genre, CONCAT('$', COUNT(rental_money)) as gross_revenue
FROM gross_rev
GROUP BY name
ORDER by COUNT(rental_money) DESC;

### 7.Is "Academy Dinosaur" available for rent from Store 1?

### Yes, it 4 copies are available for rent in store 1!

SELECT A.store_id,  B.title
FROM store as A
JOIN inventory as I
ON A.store_id=I.store_id
JOIN film as B
ON I.film_id= B.film_id
HAVING title = 'ACADEMY DINOSAUR';


