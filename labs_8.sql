##############################
###########Labs 01############
##############################
#1
use sakila;
#2
SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM customer;
#3
SELECT title FROM film;
#4
SELECT DISTINCT(name) AS language FROM language;
#5.1
SELECT count(store_id) FROM store;
#5.2
SELECT count(staff_id) FROM STAFF;
#5.3
SELECT distinct(first_name) FROM STAFF;
##############################
###########Labs 02############
##############################
#1
SELECT first_name FROM actor WHERE first_name = 'Scarlett';
#2
SELECT last_name FROM actor WHERE last_name = 'Johansson';
#3
SELECT count(film_id) FROM film;
#4
SELECT count(rental_id) FROM rental;
#5
SELECT min(rental_duration) FROM film;
SELECT max(rental_duration) FROM film;
#6
SET @min_length = (SELECT min(length) FROM film);
SET @max_length = (SELECT max(length) FROM film);
#7
SET @avg_length = (SELECT avg(LENGTH) FROM film);
#8
SELECT @avg_length DIV 60 AS hrs, @avg_length % 60 AS min;
#9
SELECT COUNT(LENGTH) FROM film WHERE length > 180;
#10
SELECT CONCAT(first_name,' ',last_name,' ','-',' ',email) FROM customer;
#11
SELECT max(length(title)) FROM film;
##############################
###########Labs 03############
##############################
#1
SELECT count(DISTINCT(last_name)) FROM actor;
#2
SELECT count(DISTINCT(Llanguage_id)) FROM film;
#3
SELECT count(rating) FROM film WHERE rating = 'PG-13';
#4
SELECT title FROM film WHERE release_year = '2006' LIMIT 10;
#5
SET @last_date = (select payment_date FROM payment ORDER BY payment_date DESC LIMIT 1);
SET @first_date = (select payment_date FROM payment ORDER BY payment_date ASC LIMIT 1);
SELECT datediff(@last_date,@first_date);
#6
SELECT MONTH(rental_date), WEEKDAY(rental_date) FROM rental LIMIT 20;
#7
SELECT rental_date,
CASE
WHEN WEEKDAY(rental_date) = 5 OR 6 THEN 'weekend'
ELSE 'weekday'
END AS 'day_type'
FROM rental;
#8
SELECT count(rental_date) FROM rental WHERE YEAR(rental_date)=2006 AND MONTH(rental_date)=2;
##############################
###########Labs 04############
##############################
#1
SELECT rating FROM film;
#2
SELECT release_yearFROM film;
#3
SELECT * FROM film WHERE title REGEXP 'ARMAGEDDON';
#4
SELECT * FROM film WHERE title REGEXP 'APOLLO';
#5
SELECT * FROM film WHERE title REGEXP 'APOLLO$';
#6
SELECT * FROM film WHERE title REGEXP 'DATE';
#7
SELECT title FROM film ORDER BY length(title) DESC LIMIT 10;
#8
SELECT title FROM film ORDER BY LENGTH DESC LIMIT 10;
#9
SELECT title FROM film WHERE special_features REGEXP 'Behind the Scenes';
#10
SELECT title,release_year FROM film ORDER BY release_year ASC , title ASC;
##############################
###########Labs 05############
##############################
#1
ALTER TABLE STAFF
DROP COLUMN PICTURE;

#2
INSERT INTO staff
(staff_id , active , username , password , last_update , first_name , last_name , address_id , email , store_id) 
values( 3 , 1 , 'TAMMY','verygood_password123', '2006-02-15 03:57:16',
(SELECT first_name FROM customer WHERE first_name = 'TAMMY' AND last_name = 'SANDERS'),
(SELECT last_name FROM customer WHERE first_name = 'TAMMY' AND last_name = 'SANDERS'),
(SELECT address_id FROM customer WHERE first_name = 'TAMMY' AND last_name = 'SANDERS'),
(SELECT email FROM customer WHERE first_name = 'TAMMY' AND last_name = 'SANDERS'),
(SELECT store_id FROM customer WHERE first_name = 'TAMMY' AND last_name = 'SANDERS'));

SELECT * FROM STAFF;

#3
INSERT INTO rental(rental_date,inventory_id,customer_id,return_date,staff_id,last_update)
values(
now(),
(SELECT count(inventory_id) FROM inventory WHERE film_id = (SELECT film_id FROM sakila.film WHERE title = 'Academy Dinosaur')),
(SELECT customer_id FROM sakila.customer WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER'),
(SELECT date_add(now(), INTERVAL 2 DAY)),
(SELECT staff_id FROM sakila.STAFF WHERE first_name = 'Mike' AND last_name = 'Hillyer'),
'2006-02-15 21:30:53'
);

SELECT * from rental order by rental_date desc;

#4
DROP TABLE IF EXISTS deleted_users;
CREATE TABLE deleted_users (
  `customer_id` int UNIQUE NOT NULL,
  `store_id` INT DEFAULT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name`  varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `adress_id` int DEFAULT NULL,
  `active` int DEFAULT NULL,
  `create_date` TIMESTAMP DEFAULT NULL,
  `last_update` TIMESTAMP DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (CUSTOMER_ID)
);
INSERT INTO deleted_users SELECT * FROM CUSTOMER;
SELECT * FROM deleted_users;
DELETE FROM deleted_users where active = 0;
SELECT count(active) FROM deleted_users WHERE active = 0;
##############################
###########Labs 06############
##############################
DROP TABLE IF EXISTS films_2020;
CREATE TABLE `films_2020` (
  `film_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `release_year` year(4) DEFAULT NULL,
  `language_id` tinyint(3) unsigned NOT NULL,
  `original_language_id` tinyint(3) unsigned DEFAULT NULL,
  `rental_duration` int(6),
  `rental_rate` decimal(4,2),
  `length` smallint(5) unsigned DEFAULT NULL,
  `replacement_cost` decimal(5,2) DEFAULT NULL,
  `rating` enum('G','PG','PG-13','R','NC-17') DEFAULT NULL,
  PRIMARY KEY (`film_id`),
  CONSTRAINT FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8;

UPDATE films_2020 SET rental_duration = 3 , rental_rate = 2.99 , replacement_cost = 8.99 ;

SELECT * FROM films_2020;
##############################
###########Labs 07############
##############################
#1
SELECT last_name FROM actor GROUP BY last_name HAVING COUNT(last_name) = 1;

#2
SELECT last_name FROM actor GROUP BY last_name HAVING COUNT(last_name) > 1;

#3
SELECT staff_id, count(rental_id) AS 'Number of rentals' FROM rental GROUP BY staff_id;

#4
SELECT release_year, count(title) AS 'Number of films' FROM film GROUP BY release_year;

#5
SELECT rating, count(title) AS 'Number of films' FROM film GROUP BY rating;

#6
SELECT rating, round(avg(length),2) AS 'Average length of film' FROM film GROUP BY rating;

#7
SELECT rating, round(avg(length),2) AS 'Average length of film' FROM film GROUP BY rating HAVING avg(length) > 120;
##############################
###########Labs 08############
##############################
#1
select title, length, rank() over (partition by length order by title asc) as ranking from film;

#2
select rating, length, rank() over (partition by length order by rating asc) as ranking from film;

#3
SELECT category.name AS 'category', count(film_category.film_id) AS 'Number of films'
FROM category
INNER JOIN film_category ON film_category.category_id=category.category_id 
group by name;

#4
SELECT actor.first_name AS 'Name of the actor', count(film_actor.film_id) AS 'Number of films'
FROM film_actor
INNER JOIN actor ON actor.actor_id = film_actor.actor_id
group by first_name
ORDER BY count(film_actor.film_id) desc;

#5
SELECT customer.first_name AS 'Name of the customer', count(rental.customer_id) AS 'Number of rentals'
FROM rental
INNER JOIN customer ON rental.customer_id = customer.customer_id
group by first_name
ORDER BY count(rental.customer_id) desc;

#BONOUS
SELECT * FROM film;
SELECT * FROM inventory;
SELECT * FROM rental;

/*
Relations:
Inventory/film: film_id
Inventory/rental: inventory_id
rental/film: - 

|rental| ---inventory_id---> |inventory| ----film_id---> |film|

joins w/ 3 tables:

SELECT *
  FROM table1
  INNER JOIN table2
  ON table1.id = table2.id
  INNER JOIN table3
  ON table2.id = table3.id;
*/

SELECT film.title AS 'Name of the film', count(rental.rental_id) AS 'Number of rentals'
FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
group by film.title
ORDER BY count(rental.rental_id) desc
limit 1;
