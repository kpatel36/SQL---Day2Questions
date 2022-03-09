-- 	QUESTION #1 - LIST ALL CUSTOMERS WHO LIVE IN TEXAS
-- table - address (address_id, address, address2) and customer(first_name, last_name, address_id,)
-- filter: district from address where district like 'Texas' there are 5 people living in texas
-- print - first_name, last_name district - connect at address_id

select first_name, last_name, address.district 
from customer
join address
on customer.address_id = address.address_id
where address.district = 'Texas';

-- ANSWER: Jennifer Davis, Kim Cruz, Richard Mccrary, Bryan Hardison, Ian Still


-- QUESTION #2 - GET ALL PAYMENTS ABOVE $6.99 WITH THE CUSTOMER'S FULL NAME 
-- customer(customer_id, store_id, first_name,last_name) and payment (payment_id, customer_id, staff_id, rental_id, amount, payment_date) tables
-- common column: customer_id
-- include: first_name, last_name 
-- filter: where amount = 6.99(payment table)
select first_name, last_name,payment_id, payment.amount
from customer
join payment
on customer.customer_id = payment.customer_id 
where payment.amount >= 6.99


-- QUESTION #3 - SHOW ALL CUSTOMERS NAMES WHO HAVE MADE PAYMENTS OVER $175
-- customer (customer_id, first name, last_name) and payment (payment_id, customer_id, staff_id, rental_id, amount)
-- select * from payment where amount > 175
select first_name, last_name, customer.customer_id, payment.amount
from customer
join payment 
on customer.customer_id = payment.customer_id 
where payment.amount > 175

-- QUESTION 3 USING SUBQUERIES 
select first_name  || ' ' || last_name as  FullName from customer where customer_id in (
	select customer_id from payment group by customer_id having sum(amount) >175)


-- QUESTION #4 - LIST ALL CUSTOMERS THAT LIVE IN NEPAL (CITY TABLE)
-- city table (city_id, city, country_id) , address(address_id, addess, address2, district, city_id), country = (country_id, country)
-- join city to country on country_id
-- join city to address on city_id
-- join address to customer on address_id 
-- select * from country where country = 'Nepal'

select  customer.first_name, customer.last_name, city, city.country_id, country.country, address.address, address.postal_code 
from city 
join country on city.country_id = country.country_id
join address on city.city_id = address.city_id 
join customer on address.address_id = customer.address_id 
where country.country = 'Nepal'
-- Kevin Schuler is the only customer living in Nepal

-- QUESTION #5 - WHICH STAFF MEMBER HAD THE MOST TRANSACTIONS
-- staff table(staff_id, first_name, last_name, store_id, ) payment (staff_id, payment_id, customer_id, rental_id)
select staff.staff_id, first_name, last_name, count(staff.staff_id)
from staff
join payment 
on staff.staff_id = payment.staff_id 
group by staff.staff_id 
order by count(staff.staff_id) 
-- Staff member Jon Stephens had the most transactions

-- use subquery to select only staff_id and only return the one staff_id using limit clause
select * from staff where staff_id in ( 
	select staff_id from payment group by staff_id order by count(staff_id) desc limit 1 
);
-- Jon Stephens had the most transactions 


-- Question 5 interpreting transactions as rentals and using a join 
select rental.staff_id, count(rental.staff_id), first_name, last_name from rental
join staff on rental.staff_id = staff.staff_id 
group by rental.staff_id, first_name, last_name 
order by count(rental.staff_id);
-- Mike Hilleyer had the most rental transactions 

-- QUESTION #6 - HOW MANY MOVIES OF EACH RATING ARE THERE
-- film_category (film_id, category_id) film(film_id, title, rating)
select rating,count(rating) from film
join film_category on film.film_id = film_category.film_id
group by rating 
order by count(rating)

-- QUESTION #7 - SHOW ALL CUSTOMERS WHO HAVE MADE A SINGLE PAYMENT ABOVE 6.99 (SUBQUERIES)
-- customer table (customer_id, store_id, first_name, last_name) and payment table (payment_id, customer_id, staff_id, rental_id, amount)
select customer.customer_id, first_name, last_name, payment.amount from customer join payment
on customer.customer_id = payment.customer_id where payment.amount > 6.99
-- Question #7 with Subqueries
select * from customer
where customer_id in (    
	select customer_id from payment where amount > 6.99
);
-- 538 customers


-- QUESTION #8 - HOW MANY FREE RENTALS DID OUR STORE GIVE AWAY
-- rental (rental_id, rental_date, )
select * from rental join payment on rental.rental_id = payment.rental_id where payment.amount = 0  
-- 23

-- option #2
select count(payment_id) from payment where amount = 0;
-- 23

-- follow up - which staff member is giving away more free rentals 
-- let's use a subquery - design a query returning a staff_id based on count of free rentals 
select * 
from staff 
where staff_id in (
	select staff_id
	from payment
	where amount = 0
	group by staff_id
	order by count(rental_id) desc
	limit 1);
-- Mike Hilleyer is giving away more free rentals
-- redo using multijoin to get full information
select staff.staff_id, first_name, last_name, email, staff.store_id, address, district, city, country from staff
join store on staff.store_id = store.store_id 
join address on store.address_id = address.address_id 
join city on address.city_id = city.city_id 
join country on city.country_id = country.country_id 
where staff_id in 
	select staff_id from payment where amount = 0 group by staff_id order by count(rental_id) desc limit 1);

	
-- follow up 2 - which films are given away as free rentals
select payment.rental_id, rental.inventory_id, inventory.film_id, film.title, film.description, amount  from payment 
join rental on payment.rental_id = rental.rental_id 
join inventory on rental.inventory_id = inventory.inventory_id 
join film on inventory.film_id = film.film_id 
where amount = 0


-- Question 6.2 - how many movies of each category are there?
select film_category.category_id, category.name, count (film_category.film_id) from film_category
join category on film_category.category_id = category.category_id
group by film_category.category_id , category.name 
order by count (film_category.film_id) desc;


