USE sakila;
#Challenge 1
#Ex1: As a movie rental company, we need to use SQL built-in functions to help us gain insights into our business operations:
#1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SHOW TABLES;
SELECT MIN(length) AS min_duration, MAX(length) AS max_duration FROM film;

#1.2. Express the average movie duration in hours and minutes. Don't use decimals. Hint: look for floor and round functions.
SELECT CONCAT(FLOOR(AVG(length) / 60), 'hours', ROUND(AVG(length) % 60),' minutes') AS average_duration FROM film;

#Ex2: We need to use SQL to help us gain insights into our business operations related to rental dates:
#2.1. Calculate the number of days that the company has been operating.
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) AS operating_days FROM rental; 

#2.2. Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT *,
       MONTH(rental_date) AS rental_month,
       DAYNAME(rental_date) AS rental_weekday
FROM rental
LIMIT 20;

#2.3 Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week. Hint: use a conditional expression.SELECT *,
    SELECT *,
    CASE 
           WHEN DAYOFWEEK(rental_date) IN (1, 7) THEN 'weekend'
           ELSE 'workday'
       END AS DAY_TYPE
FROM rental;

#Ex3: We need to ensure that our customers can easily access information about our movie collection. To achieve this, retrieve the film titles and their rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results by the film title in ascending order. Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future;
SELECT title, ifnull (rental_duration,'Non-avaliable') AS rental_duration FROM film order by title ASC; 

#Ex4: As a marketing team for a movie rental company, we need to create a personalized email campaign for our customers. To achieve this, we want to retrieve the concatenated first and last names of our customers, along with the first 3 characters of their email address, so that we can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier for us to use the data.
SELECT CONCAT(last_name, " ", first_name) as full_name, LEFT(email,3) as email_prefix from customer ORDER BY last_name ASC;

#Challenge 2
#Ex1: We need to analyze the films in our collection to gain insights into our business operations. Using the film table, determine:
#1.1 The total number of films that have been released.
SELECT  COUNT(*)  from film;
#1.2 The number of films for each rating.
SELECT* from film;
SELECT DISTINCT(rating), count(rating) as  film_for_each_rating from film  group by rating;
#1.3 The number of films for each rating, and sort the results in descending order of the number of films. This will help us better understand the popularity of different film ratings and adjust our purchasing decisions accordingly.
SELECT DISTINCT(rating), count(rating) as  film_for_each_rating
from film
group by rating
ORDER BY rating DESC;

#Ex2: We need to track the performance of our employees. Using the rental table, determine the number of rentals processed by each employee. This will help us identify our top-performing employees and areas where additional training may be necessary.alter
SELECT count(customer_id) as number_rental_employee from rental;

#Ex3: Using the film table, determine:
#3.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help us identify popular movie lengths for each category.
SELECT rating, ROUND(AVG(length), 2) AS mean_duration
FROM film
GROUP BY rating
ORDER BY mean_duration DESC;
SELECT title, length, rating from film;

#3.2 Identify which ratings have a mean duration of over two hours, to help us select films for customers who prefer longer movies.
SELECT rating, ROUND(AVG(length), 2) AS mean_duration
FROM film
GROUP BY rating
HAVING mean_duration > 120;

#Ex4: Determine which last names are not repeated in the table actor.
SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) = 1;