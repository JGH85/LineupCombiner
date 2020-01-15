--CREATE TABLE players_cleaned AS TABLE players with no data;

--insert team names into team table. (this shouldn't be needed as teams don't change)

--for the sections below, run the select to see what will be added and then run it with the insert from the line above selected to insert the data

-- INSERT INTO team (abbreviation)
SELECT DISTINCT tmp.Team
FROM raw_data_2019 tmp
WHERE team NOT IN (SELECT DISTINCT abbreviation FROM team)

select * from team

--shouldn't need to do this again since positions don't change
--insert into position (abbreviation) 
SELECT DISTINCT tmp.pos
FROM raw_data_2019 tmp
WHERE pos NOT IN (SELECT DISTINCT abbreviation FROM position)

-- update position set position_name = 'Tight End', flex_yn = 'Y' where abbreviation = 'TE';
-- update position set position_name = 'Wide Receiver', flex_yn = 'Y' where abbreviation = 'WR';
-- update position set position_name = 'Running Back', flex_yn = 'Y' where abbreviation = 'RB';
-- update position set position_name = 'Kicker', flex_yn = 'N' where abbreviation = 'PK';
-- update position set position_name = 'Quarter Back', flex_yn = 'N' where abbreviation = 'QB';
-- update position set position_name = 'Defense', flex_yn = 'N' where abbreviation = 'Def';

--insert into player (gid, name, position_id) 
SELECT DISTINCT tmp.gid, tmp.name, p.position_id
FROM raw_data_2019 tmp
left outer join position p on p.abbreviation = tmp.pos
WHERE gid NOT IN (SELECT DISTINCT gid FROM player)


--insert into game (week, year, home_team_id, away_team_id) 
SELECT DISTINCT tmp.week, tmp.year, ht.team_id, at.team_id
FROM raw_data_2019 tmp
inner join team ht on ht.abbreviation = tmp.team 
inner join team at on at.abbreviation = tmp.oppt
where "h/a" = 'h' 
order by ht.team_id, year, week

--insert into player_game (game_id, player_id, dk_salary, fd_salary, dk_points, fd_points)
select distinct g.game_id, p.player_id, tmp.dk_salary, tmp.fd_salary, tmp.dk_points, tmp.fd_points
from raw_data_2019 tmp
inner join team t on t.abbreviation = tmp.team
inner join game g on g.week = tmp.week and g.year = tmp.year and (g.home_team_id = t.team_id or g.away_team_id = t.team_id)
inner join player p on p.gid = tmp.gid
order by dk_salary desc


--get all games from Lamar Jackson for 2019
select * from player
left outer join player_game pg on pg.player_id = player.player_id
left outer join game g on g.game_id = pg.game_id
where gid = 1527
and year = 2019


