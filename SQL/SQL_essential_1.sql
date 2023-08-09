
--1.Retrieve all information from the 'dataset' table.

select *
from dataset;

--2.Retrieve the title, imprint, rating, number of ratings, and language.

select title,imprint,rating_avg,rating_count,lang
from dataset;

--3.Which languages are present in the dataset table?

select distinct lang
from dataset
where lang is not null;

--4.Find the books that have the word 'history' anywhere in their title.

select title
from dataset
where title like '%history%';

--5.Find the books in Spanish('hi)', Italian('it') and Greek('el')

select title,lang
from dataset
where lang in ('hi','it','el');

--6.Titles: (a) Find the titles with the highest average ratings (rating = 5)

select title, rating_avg, rating_count
from dataset
where rating_avg = 5;

--6.Titles: (b) Which title(s) from this set have above 20 rating counts?

select title, rating_avg, rating_count
from dataset
where rating_avg = 5 and rating_count > 20;

--7.Which editor (imprint) published the highest number of titles between 2010 and 2020?

select imprint, count(title)
from dataset
where publication_date between '2010-01-01' and '2020-12-31' and imprint is not null and publication_date is not null --or '2010/01/01' could work
group by imprint
order by count(title) DESC
limit 1;

/*
SELECT count(title), imprint
FROM dataset
WHERE publication_date between '2010-01-01' AND '2020-12-31' 
--v2: WHERE left(publication_date, 4) between '2010' and '2020'
--v3: WHERE publication_date between '2010' AND '2020' 
--v4: WHERE extract(year from cast(publication_date as date)) between 2010 and 2020
AND  publication_date IS NOT NULL 
AND imprint IS NOT NULL
GROUP BY imprint 
ORDER BY count(title) DESC
LIMIT 1
*/

--8.Format: (a) Which is the most published format from MIT Press?

select format , count(format)
from dataset
where imprint = 'MIT Press'
group by format
order by count(format) DESC
limit 1;

/*
select format_name
from formats
where format_id in 
(select MIT_Format.format from (select format,count(imprint) from dataset where imprint='MIT Press' group by format order by count(imprint) DESC limit 1) as MIT_Format)

*/
--8.Format: (b) Which editors publish in leather format?

select distinct dataset.imprint
from dataset inner join formats
on formats.format_id = dataset.format
where formats.format_name = 'Leather';

/* 

or with Subquery instead of JOIN

select distinct imprint 
from dataset
where format in (select format_id 
				  from formats 
				  where format_name = 'Leather'); --or like instead of =

 */


--8.Format: (c) How many books are in each format?

select formats.format_name, count(dataset.title)
from dataset inner join formats
on formats.format_id = dataset.format
group by formats.format_name
order by count(dataset.title) DESC;

/*
select format,count(id)
from dataset 
where format is not null 
group by format
order by format ASC
*/

--9.Find the titles of the top 100 best sellers

select 
	title,bestsellers_rank
from 
	dataset
where bestsellers_rank is not null
order by 
	bestsellers_rank ASC
limit 100;

--10.Display the formats where the last characters are "back"

select format_name
from formats
where format_name like '%back';

--11.What is the format name from users table where has the minimum count (display the minimum also)?

select format_name, count
from users
order by count ASC
limit 1;



--12.Find the descriptions (from dataset) with publication date in 2019 (sort them from 1st January until the end of the year)

select description, publication_date
from dataset
where publication_date between '2019-01-01' and '2019-12-30'
order by publication_date ASC;

--13.Find how many descriptions (from dataset) doesn't have rating

select count(distinct description)
from dataset
where rating_count = 0 or rating_count is null;


