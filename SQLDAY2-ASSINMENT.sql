-- 	QUESTION #1 - LIST ALL CUSTOMERS WHO LIVE IN TEXAS
-- table - address (address_id, address, address2) and customer(first_name, last_name, address_id,)
-- filter: district from address where district like 'Texas' there are 5 people living in texas
-- print - first_name, last_name district - connect at address_id

select first_name, last_name, address.district 
from customer
join address
on customer.address_id = address.address_id
where address.district = 'Texas';

-- QUESTION #2 - GET ALL PAYMENTS ABOVE $6.99 WITH THE CUSTOMER'S FULL NAME 
-- customer(customer_id, store_id, first_name,last_name) and payment (payment_id, customer_id, staff_id, rental_id, amount, payment_date) tables
-- common column: customer_id
-- include: first_name, last_name 
-- filter: where amount = 6.99(payment table)
select first_name, last_name,payment.amount 
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


-- QUESTION #4 - LIST ALL CUSTOMERS THAT LIVE IN NEPAL (CITY TABLE)
-- city table (city_id, city, country_id) , address(address_id, addess, address2, district, city_id), country = (country_id, country)
-- join city to country on country_id
-- join city to address on city_id
-- join address to customer on address_id 
-- select * from country where country = 'Nepal'

select city, city.country_id, country.country, address.address, address.postal_code, customer.first_name, customer.last_name 
from city
join country
on city.country_id = country.country_id
join address
on city.city_id = address.city_id 
join customer 
on address.address_id = customer.address_id 
where country.country = 'Nepal'


-- QUESTION #5 - WHICH STAFF MEMBER HAD THE MOST TRANSACTIONS
-- staff table(staff_id, first_name, last_name, store_id, ) payment (staff_id, payment_id, customer_id, rental_id)
select staff.staff_id, first_name, last_name, count(staff.staff_id)
from staff
join payment 
on staff.staff_id = payment.staff_id 
group by staff.staff_id 
order by count(staff.staff_id) 
-- Staff member Jon Stephens had the most transactions


-- QUESTION #6 - HOW MANY MOVIES OF EACH RATING ARE THERE
-- film_category (film_id, category_id) film(film_id, title, rating)
-- 
select *,count(rating)
from film
join film_category
on film.film_id = film_category.film_id
group by film.film_id, rating 
order by count(rating)

-- QUESTION #7 - SHOW ALL CUSTOMERS WHO HAVE MADE A SINGLE PAYMENT ABOVE 6.99 (SUBQUERIES)
-- customer table (customer_id, store_id, first_name, last_name) and payment table (payment_id, customer_id, staff_id, rental_id, amount)
select customer.customer_id, first_name, last_name, payment.amount
from customer
join payment
on customer.customer_id = payment.customer_id 
where payment.amount > 6.99

-- QUESTION #8 - HOW MANY FREE RENTALS DID OUR STORE GIVE AWAY
-- rental (rental_id, rental_date, )
select * from rental join payment on rental.rental_id = payment.rental_id where payment.amount = 0  
-- 24