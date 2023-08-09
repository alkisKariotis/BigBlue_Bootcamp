/*Today we will access the data of the NBA!
The database in the server is nba_games
Connect to the database, list the tables and and answer the following questions: */

--1.a Find all allstar MVP players.

select distinct players.full_name 
from players
inner join allstar_mvps on players.id = allstar_mvps.player_id;

--1.b Find all players born in New York.

select full_name, birth_place
from players 
where birth_place like '%New York%';

--1.c Which players born in New York hold a MVP title?

select distinct players.full_name, players.birth_place
from players
inner join allstar_mvps on players.id = allstar_mvps.player_id
where birth_place like '%New York%';

--2. Which players have the same height?

select D.full_name as player1, B.full_name as player2, D.height 
from players as D, players as B
where D.height = B.height and D.id <> B.id;
--where D.player_1 <> B.player_2 and D.height = B.height;

select D.full_name as player_1, B.full_name as player_2 , D.height 
from players as D, players as B
--where D.height = B.height and D.id <> B.id;
where D.full_name <> B.full_name and D.height = B.height;

--cannot use the aliases on the where section 
/*
select * from (select D.full_name as player_1, B.full_name as player_2, D.height as h1, B.height as h2
from players as D, players as B) as A
--where D.height = B.height and D.id <> B.id;
where player_1 <> player_2 and h1 = h2;
*/

--3. List the top 10 of the players having the most Player of the Month Awards.

select players.full_name,count(monthly_player_awards.award_type)
from players 
inner join monthly_player_awards on players.id = monthly_player_awards.player_id
group by players.full_name
order by count(monthly_player_awards.award_type) DESC
limit 10; 

--4. Using table teams, create a new column that writes the messages "More than 2000 wins", "2000 wins" or "Less than 2000 wins" depending the number of wins it has,
-- and also print the name and the number of wins for each team.

select team_name, total_wins,
		Case 
			when total_wins > 2000 then 'More than 2000 wins'
			when total_wins = 2000 then '2000 wins'
			else 'Less than 2000 wins'
		end new_column
from teams;

--5.a  Create a view with the team id, team name and number of championships.

create view team_view as
	select team_id, team_name, champions
	from teams;
	

--5.b Print from the view all the teams from Miami or Milwaukee that have a championship.

select *
from team_view
where team_name like '%Miami%' and team_name like '%Milwaukee%' and champions > 0 ;

--5.c Update view with total wins and total loses.

create or replace view team_view as 
select team_id, team_name, champions,total_wins,total_losses
from teams;

--6. Find all players that have both awards and other awards and print the name of the award as well.

select a.full_name, b.award, c.award as other_award
from players as a
inner join player_awards as b on a.id = b.player_id
inner join other_player_awards as c on a.id = c.payer_id;
