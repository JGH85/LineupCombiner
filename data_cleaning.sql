-- INSERT INTO tbl_Product (ProductCode, ProductDescription, ProductType)
-- SELECT DISTINCT tmp.ProductCode,tmp.ProductName, pt.ProductType
-- FROM tbl_tmpData tmp
-- INNER JOIN tbl_ProductType pt ON tmp.ProductType = pt.ProductType
-- WHERE ProductCode NOT IN (SELECT DISTINCT ProductCode FROM tbl_Product)

-- INSERT INTO tbl_Product (ProductCode, ProductDescription, ProductType)
-- SELECT DISTINCT tmp.ProductCode,tmp.ProductName, pt.ProductType
-- FROM tbl_tmpData tmp
-- INNER JOIN tbl_ProductType pt ON tmp.ProductType = pt.ProductType
-- WHERE ProductCode NOT IN (SELECT DISTINCT ProductCode FROM tbl_Product)


CREATE TABLE players_cleaned AS TABLE players with no data;

--insert team names into team table
INSERT INTO team (abbreviation)
SELECT DISTINCT tmp.team
FROM players tmp
WHERE team NOT IN (SELECT DISTINCT abbreviation FROM team)

select * from team

--insert into position (abbreviation) 
SELECT DISTINCT tmp.pos
FROM players tmp
WHERE pos NOT IN (SELECT DISTINCT abbreviation FROM position)

-- update position set position_name = 'Tight End', flex_yn = 'Y' where abbreviation = 'TE';
-- update position set position_name = 'Wide Receiver', flex_yn = 'Y' where abbreviation = 'WR';
-- update position set position_name = 'Running Back', flex_yn = 'Y' where abbreviation = 'RB';
-- update position set position_name = 'Kicker', flex_yn = 'N' where abbreviation = 'PK';
-- update position set position_name = 'Quarter Back', flex_yn = 'N' where abbreviation = 'QB';
-- update position set position_name = 'Defense', flex_yn = 'N' where abbreviation = 'Def';

--insert into player (gid, name, position) 
SELECT DISTINCT tmp.gid, tmp.name, p.position_id
FROM players tmp
left outer join position p on p.abbreviation = tmp.pos
WHERE gid NOT IN (SELECT DISTINCT gid FROM player)


--insert into game (week, year, home_team_id, away_team_id) 
SELECT DISTINCT tmp.week, tmp.year, ht.team_id, at.team_id
FROM players tmp
inner join team ht on ht.abbreviation = tmp.team 
inner join team at on at.abbreviation = tmp.oppt
where "h/a" = 'h' 
order by ht.team_id, year, week

--insert into player_game (game_id, player_id, dk_salary, fd_salary, dk_points, fd_points)
select distinct g.game_id, p.player_id, tmp.dk_salary, tmp.fd_salary, tmp.dk_points, tmp.fd_points
from players tmp
inner join team t on t.abbreviation = tmp.team
inner join game g on g.week = tmp.week and g.year = tmp.year and (g.home_team_id = t.team_id or g.away_team_id = t.team_id)
inner join player p on p.gid = tmp.gid
order by dk_salary desc


select * from player where player_id = 577
select * from players where gid = 6194



