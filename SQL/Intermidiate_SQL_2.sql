--Advanced SQL

--From lahman2017 baseball database answer the following:


--1. Which player hit the most home runs in 2002?

select
	master.namefirst,
	master.namelast ,
	master.namegiven ,
	batting.hr
from
	master
inner join batting on
	master.playerid = batting.playerid
where
	batting.yearid = '2002'
order by
	batting.hr desc
limit 1;

/*  OR USING THE MAX FUNCTION 


select
	master.namefirst,
	master.namelast ,
	master.namegiven ,
	batting.hr
from
	master
inner join batting on
	master.playerid = batting.playerid
where
	batting.hr = (
	select
			max(hr)
	from
			batting
	where
			yearid = '2002')
	and batting.yearid = '2002'
*/

--2. Which team spent the most/least money on player salaries in 2002?

select
	*
from
	(
	select
		teamid ,
		sum(salary) as money_spent
	from
		salaries
	where
		yearid = '2002'
	group by
		teamid
	order by
		money_spent desc
	limit 1) maximum
union 
select
	*
from
	(
	select
		teamid ,
		sum(salary) as money_spent
	from
		salaries
	where
		yearid = '2002'
	group by
		teamid
	order by
		money_spent asc
	limit 1) minimum

--3. Which player averaged the fewest at bats between home runs in 2002?



--4. Which player in 2002 had the highest on-base percentage?
--5. Which Yankees pitcher had the most wins in a season in the 00’s?
--6. Which Yankees pitcher had the most wins between 1999 and 2009?
--7. In the 2000’s, did the Yankees draw more or fewer walks (Base-on-Balls or BB) as the decade went on?