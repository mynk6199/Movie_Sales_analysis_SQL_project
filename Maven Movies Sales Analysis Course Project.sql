/* MAVEN MOVIES COURSE PROJECT PART 1 */

use mavenmovies;

/*
1.	We will need a list of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. 
*/ 
select 
	first_name,
	last_name,
	email,
	store_id
from staff;



/*
2.	We will need separate counts of inventory items held at each of your two stores. 
*/ 
select
	store_id,
	count(inventory_id) as inventory
from inventory
group by 1;



/*
3.	We will need a count of active customers for each of your stores. Separately, please. 
*/
select * from customer;
select
	store_id,
	count(case when active = '1' then customer_id else null end) as active_customers
from customer
group by 1;

-- from another way
select 
	store_id,
    count(customer_id) as active_customer
from customer
where active = '1'
group by 1;
    
/*
4.	In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. 
*/
select
	count(email) as emails
from customer
;



/*
5.	We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. Please provide a count of unique film titles 
you have in inventory at each store and then provide a count of the unique categories of films you provide. 
*/
select 
	store_id,
    count( distinct film_id) as film_titles
from inventory
group by 1;

-- another way
select
	count(distinct case when store_id = '1' then film_id else  null end) as store_1_inventory,
	count(distinct case when store_id = '2' then film_id else  null end) as store_2_inventory
from inventory;
    
select
	count(category_id) as category
from film_category;

-- correct
select * from category;

select 
	count(distinct name) as unique_categ
from category;

/*
6.	We would like to understand the replacement cost of your films. 
Please provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
*/
select * from film;

select 
	min(replacement_cost) as least_expensive,
    max(replacement_cost) as most_expensive,
    avg(replacement_cost) as avg_cost
from film;


/*
7.	We are interested in having you put payment monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
*/
select
	avg(amount) as avg_payment,
    max(amount) as max_payment
from payment;


/*
8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals 
they have made all-time, with your highest volume customers at the top of the list.
*/
select
	customer_id,
    count(rental_id) as total_rental
from rental
group by 1
order by 2 desc;



/* MAVEN MOVIES COURSE PROJECT PART 2*/

use mavenmovies;

/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 
select
	staff.first_name,
    staff.last_name,
    address.address,
    address.address2,
    address.district,
    city.city,
	country.country
from store
left join staff on store.manager_staff_id = staff.staff_id
left join address on store.address_id = address.address_id
left join city on address.city_id = city.city_id
left join country on city.country_id = country.country_id
;

	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
select 
	inventory.store_id,
    inventory.inventory_id,
    film.title,
    film.rating,
    film.rental_rate,
    film.replacement_cost
from inventory
left join film on inventory.film_id = film.film_id;

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
select 
	film.rating,
	inventory.store_id,
    count(inventory.inventory_id) as total_inventory
from inventory
left join film on inventory.film_id = film.film_id
group by 1,2;


/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
select * from inventory;
select 
	inventory.store_id,
	category.name as category,
    count(inventory.film_id) as films,
    avg(film.replacement_cost) as avg_cost,
	sum(film.replacement_cost) as total_cost
from inventory 
left join film on inventory.film_id = film.film_id
left join film_category on film.film_id = film_category.film_id
left join category on film_category.category_id = category.category_id
group by 1,2
order by 5 desc;

-- another way just change the table name in count row inventory to film

select 
	inventory.store_id,
	category.name as category,
    count(film.film_id) as films,
    avg(film.replacement_cost) as avg_cost,
	sum(film.replacement_cost) as total_cost
from inventory 
left join film on inventory.film_id = film.film_id
left join film_category on film.film_id = film_category.film_id
left join category on film_category.category_id = category.category_id
group by 1,2
order by 5 desc;


/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/
select
	customer.first_name,
    customer.last_name,
    customer.store_id,
    customer.active,
    address.address,
    address.address2,
    city.city,
    country.country
from customer
left join address on customer.address_id = address.address_id
left join city on address.city_id = city.city_id
left join country on city.country_id = country.country_id;    

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
select 
	customer.first_name,
    customer.last_name,
    count(payment.rental_id) as total_rentals,
    sum(payment.amount) as sum_payment
from customer
left join payment on customer.customer_id = payment.customer_id 
group by 1,2
order by 4 desc;
 
 -- query from solutions but output is same
SELECT 
	customer.first_name, 
    customer.last_name, 
    COUNT(rental.rental_id) AS total_rentals, 
    SUM(payment.amount) AS total_payment_amount

FROM customer
	LEFT JOIN rental ON customer.customer_id = rental.customer_id
    LEFT JOIN payment ON rental.rental_id = payment.rental_id

GROUP BY 
	customer.first_name,
    customer.last_name

ORDER BY 
	SUM(payment.amount) DESC
    ;
    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
select * from advisor;
select * from investor;
select 
'investor' as type,
first_name,
last_name
from investor
union
select 
'advisor' as type,
first_name,
last_name
from advisor
;

/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
select * from actor_award;
select
	case 
		when actor_award.awards = 'Emmy, Oscar, Tony ' then '3 awards'
        when actor_award.awards in ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') then '2 awards'
		else '1 award'
	end as number_of_awards, 
    avg(case when actor_award.actor_id is null then 0 else 1 end) as pct_w_one_film
from actor_award
group by 1;