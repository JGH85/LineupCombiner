-- select * from players
-- where "GID" = 1151

-- select  sum("DK_points"), sum("FD_points") from players group by "GID"

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/reBWDo
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "Player" (
    "PlayerId" SERIAL   NOT NULL,
    "Name" text   NOT NULL,
    "Position" int   NOT NULL,
    "TeamId" int   NOT NULL,
    CONSTRAINT "pk_Player" PRIMARY KEY (
        "PlayerId"
     )
);

CREATE TABLE "Team" (
    "TeamId" SERIAL   NOT NULL,
    "Abbreviation" text   NOT NULL,
    "Name" text   NOT NULL,
    CONSTRAINT "pk_Team" PRIMARY KEY (
        "TeamId"
     )
);

-- Roster
-- -
-- RosterId PK int
-- TeamId int FK >- Team.TeamId
CREATE TABLE "Position" (
    "PositionId" SERIAL   NOT NULL,
    "PositionName" text   NOT NULL,
    "FlexYn" bool   NOT NULL,
    CONSTRAINT "pk_Position" PRIMARY KEY (
        "PositionId"
     )
);

CREATE TABLE "Game" (
    "GameId" SERIAL   NOT NULL,
    "Week" int   NOT NULL,
    "Year" int   NOT NULL,
    "HomeTeamId" int   NOT NULL,
    "AwayTeamId" int   NOT NULL,
    CONSTRAINT "pk_Game" PRIMARY KEY (
        "GameId"
     )
);

CREATE TABLE "PlayerGame" (
    "PlayerGameId" SERIAL   NOT NULL,
    "GameId" int   NOT NULL,
    "PlayerId" int   NOT NULL,
    "DK_salary" int   NOT NULL,
    "FD_salary" int   NOT NULL,
    "DK_points" float   NOT NULL,
    "FD_points" float   NOT NULL,
    CONSTRAINT "pk_PlayerGame" PRIMARY KEY (
        "PlayerGameId"
     )
);

ALTER TABLE "Player" ADD CONSTRAINT "fk_Player_Position" FOREIGN KEY("Position")
REFERENCES "Position" ("PositionId");

ALTER TABLE "Player" ADD CONSTRAINT "fk_Player_TeamId" FOREIGN KEY("TeamId")
REFERENCES "Team" ("TeamId");

ALTER TABLE "Game" ADD CONSTRAINT "fk_Game_HomeTeamId" FOREIGN KEY("HomeTeamId")
REFERENCES "Team" ("TeamId");

ALTER TABLE "Game" ADD CONSTRAINT "fk_Game_AwayTeamId" FOREIGN KEY("AwayTeamId")
REFERENCES "Team" ("TeamId");

ALTER TABLE "PlayerGame" ADD CONSTRAINT "fk_PlayerGame_GameId" FOREIGN KEY("GameId")
REFERENCES "Game" ("GameId");

ALTER TABLE "PlayerGame" ADD CONSTRAINT "fk_PlayerGame_PlayerId" FOREIGN KEY("PlayerId")
REFERENCES "Player" ("PlayerId");

CREATE INDEX "idx_Player_Name"
ON "Player" ("Name");


-- drop Table "Team" cascade

