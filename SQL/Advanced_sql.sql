--DATASET : Parch-posey


--1a. Look for companies which have the word 'group' anywhere in their names (case insensitive search)

select
	name
from
	accounts
where
	lower(name) like '%group%'

--1b. Remove (replace) the 'www.' and '.com' FROM the website column

select
	website,
	replace(replace(website, 'www.', ''), '.com', '')
from
	accounts;

--2a. Find the position of ' ' (space) in the representatives' names

select
	name,
	position(' ' in name)
from
	sales_reps;

--2b. Now create two columns for the first and last names of the representatives

select 
	name,
	substring(name from 1 for (position(' ' in name))) as first_name_sr,
	substring(name from position(' ' in name)) as last_name_sr
from
	sales_reps;

--3a. Create a column 'client_representative' in alphabetical order combining the name of the client company and the name of the representative.

select
	concat(accounts.name, ' ', sales_reps.name) as client_representative
from
	sales_reps
inner join accounts on
	accounts.sales_rep_id = sales_reps.id
order by
	client_representative;

--3b. How many clients does each representative have?

select
	sales_reps.name,
	count(accounts.sales_rep_id) as number_of_clients
from
	sales_reps
inner join accounts on
	accounts.sales_rep_id = sales_reps.id
group by
	sales_reps.name
order by
	number_of_clients DESC;

--4a. Create a column coordinates combining latitude and longitude separated with a comma

select
	concat(lat, ',', long) as coordinates
from
	accounts;

--4b. Create a column 'location' for each client combining latitude, longitude and the region each representative is appointed at, separated with a comma.

select
	concat(accounts.lat , ',', accounts.long , ',', region.name) as location
from
	accounts
inner join sales_reps on
	accounts.sales_rep_id = sales_reps.id
inner join region on 
	sales_reps.region_id = region.id;

--4a. When was the last entry of an order?

select
	occurred_at
from
	orders
order by
	occurred_at desc
limit 1;

--4b. How long since this last entry?

select
	age(now(),(select
	occurred_at
from
	orders
order by
	occurred_at desc
limit 1));

--4c. What day of the week was the last entry made? (0=Sunday)

select date_part('dow',(select
	occurred_at
from
	orders
order by
	occurred_at desc
limit 1)) as last_entry;

--OR
select to_char(max(occurred_at),'day') from orders;

--5a. It takes half an hour to register an order in the system. Calculate the time the orders were truly placed, 30 minutes earlier.

select
	occurred_at,
	occurred_at - interval '30 minutes' as actual_occurency
from
	orders;

--OR WITH CAST

select
	occurred_at,
	cast(occurred_at - interval '30 minutes' as timestamp) as actual_occurency
from
	orders;


--5b. Also, expected delivery is in 4 days at most. Create a column for latest delivery date (no time info needed)
--Create two new columns(qty, amt) for non-standard paper (gloss+poster) orders as 'other' and create a view of this table
--(columns : orders.id, accounts.name, orders.occurred_at, orders.standard_qty, orders.gloss_qty, orders.poster_qty, orders.total, orders.standard_amt_usd, orders.gloss_amt_usd, orders.poster_amt_usd, orders.total_amt_usd + 2 new ones)

create or replace
view orders_view as
select
	orders.id,
	accounts.name,
	orders.occurred_at,
	orders.standard_qty,
	orders.gloss_qty,
	orders.poster_qty,
	orders.total,
	orders.standard_amt_usd,
	orders.gloss_amt_usd,
	orders.poster_amt_usd,
	orders.total_amt_usd,
	cast(occurred_at + interval '4 days' as DATE),
	gloss_qty + poster_qty as other_qty,
	gloss_amt_usd + poster_amt_usd as other_amt
from
	orders
inner join accounts on
	orders.id = accounts.id;

--6a. How much standard and other quantity and amount were sold per year

select
	date_part('year', occurred_at) as years,
	sum(standard_qty) as sum_standard_qty,
	sum(other_qty) as sum_other_qty,
	sum(standard_amt_usd) as sum_standard_amt_usd,
	sum(other_amt) as sum_other_amt
from
	orders_view
group by
	years
order by
	years;

--6b. How much standard and other quantity and amount were sold during 2016 and 2017 to Walmart and Apple?

select
	name,
	sum(standard_qty) as sum_standard_qty,
	sum(other_qty) as sum_other_qty,
	sum(standard_amt_usd) as sum_standard_amt_usd,
	sum(other_amt) as sum_other_amt
from
	orders_view
where
	date_part('year', occurred_at) between '2016' and '2017'
group by
	name
having
	name like '%Apple%'
	or name like '%Walmart%'
order by
	name;

--7a. Which month has the highest sales of paper in total quantity? Can you possibly give an explanation?

select 
	date_part('month', occurred_at) as months,
	sum(total) as total_qty
from
	orders_view
group by
	months
order by
	total_qty desc
limit 1;

--7b. Which client ordered the biggest quantity of paper during December 2016?

select 
	name,
	sum(total) as total_qty
from
	orders_view
where
	date_part('month', occurred_at) = '12'
	and date_part('year', occurred_at) = '2016'
group by
	name
order by
	total_qty desc
limit 1;

--7c. How many orders are made per week, how much paper is sold on average for year 2015



--8a. How many orders are made per day of the week?


--8b. Which client company has made the most orders during weekends?


--8c. How many orders have been placed between 00:00 and 06:00?


--9a. How many orders are placed per client on Mondays and what are these orders' ids. Which client has the most?


--9b. Rank order ids based on total quantity and amount_usd sold to Supervalu during 2016. Do the RANKs of qty and amt correspond?


--9c. What is the difference in paper sales (usd total amount) month to month for  Coca-Cola and Walmart for the year 2016?