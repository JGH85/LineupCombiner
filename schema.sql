-- select * from players
-- where "GID" = 1151

-- select  sum("DK_points"), sum("FD_points") from players group by "GID"

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/reBWDo
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE player (
    player_id SERIAL   NOT NULL,
    name text   NOT NULL,
    position int   NOT NULL,
    team_id int   NOT NULL,
    CONSTRAINT pk_player PRIMARY KEY (
        player_id
     )
);

CREATE TABLE team (
    team_id SERIAL   NOT NULL,
    abbreviation text   NOT NULL,
    name text   NOT NULL,
    CONSTRAINT pk_team PRIMARY KEY (
        team_id
     )
);

-- Roster
-- -
-- RosterId PK int
-- TeamId int FK >- Team.TeamId
CREATE TABLE position (
    position_id SERIAL   NOT NULL,
    position_name text   NOT NULL,
    flexYn bool   NOT NULL,
    CONSTRAINT pk_position PRIMARY KEY (
        position_id
     )
);

CREATE TABLE game (
    game_id SERIAL   NOT NULL,
    week int   NOT NULL,
    year int   NOT NULL,
    home_team_id int   NOT NULL,
    away_team_id int   NOT NULL,
    CONSTRAINT pk_game PRIMARY KEY (
        game_id
     )
);

CREATE TABLE player_game (
    player_game_id SERIAL   NOT NULL,
    game_id int   NOT NULL,
    player_id int   NOT NULL,
    dk_salary int   NOT NULL,
    fd_salary int   NOT NULL,
    dk_points float   NOT NULL,
    fd_points float   NOT NULL,
    CONSTRAINT pk_player_game PRIMARY KEY (
        player_game_id
     )
);

ALTER TABLE player ADD CONSTRAINT fk_player_position FOREIGN KEY(position)
REFERENCES position (position_id);

ALTER TABLE player ADD CONSTRAINT fk_player_team_id FOREIGN KEY(team_id)
REFERENCES team (team_id);

ALTER TABLE game ADD CONSTRAINT fk_game_home_team_id FOREIGN KEY(home_team_id)
REFERENCES team (team_id);

ALTER TABLE game ADD CONSTRAINT fk_game_away_team_id FOREIGN KEY(away_team_id)
REFERENCES team (team_id);

ALTER TABLE player_game ADD CONSTRAINT fk_player_game_game_id FOREIGN KEY(game_id)
REFERENCES game (game_id);

ALTER TABLE player_game ADD CONSTRAINT fk_player_game_player_id FOREIGN KEY(player_id)
REFERENCES player (player_id);

CREATE INDEX idx_player_name
ON player (name);


-- drop Table "Team" cascade




