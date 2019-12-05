import numpy as np

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify


#################################################
# Database Setup
#################################################
engine = create_engine('postgresql://postgres:postgres@localhost:5432/fantasydata2018test')

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Player = Base.classes.player
PlayerGame = Base.classes.player_game

#################################################
# Flask Setup
#################################################
app = Flask(__name__)


#################################################
# Flask Routes
#################################################

@app.route("/")
def welcome():
    """Available api routes."""
    return (
        f"Routes:<br/>"
        f"/api/names<br/>"
        f"/api/players<br/>"
        f"/api/player_stats/'name'*<br/>"
        f"/api/player_games<br/>"
        f"*Name searches for any player names containing the input text, regardless of case.<br/>"
        f" Names are stored in format 'Last, First'<br/>"


    )


@app.route("/api/names")
def names():
    # Create our session (link) from Python to the DB
    session = Session(engine)

    """Return a list of all passenger names"""
    # Query all players
    results = session.query(Player.name).all()

    session.close()

    # Convert list of tuples into normal list
    all_names = list(np.ravel(results))

    return jsonify(all_names)


@app.route("/api/players")
def players():
    # Create our session (link) from Python to the DB
    session = Session(engine)

    """Return a list of passenger data including the name, age, and sex of each passenger"""
    # Query all passengers
    results = session.query(Player.name, Player.position_id).all()

    session.close()

    # Create a dictionary from the row data and append to a list of all players
    all_players = []
    for name, position_id in results:
        player_dict = {}
        player_dict["name"] = name
        player_dict["position"] = position_id
        all_players.append(player_dict)

    return jsonify(all_players)

# # TODO: Create route for player games
# @app.route("/api/v1.0/player_games")
# def player_game():
#     # Create our session (link) from Python to the DB
#     session = Session(engine)

#     """Return a list of player game data"""
#     # Query all passengers
#     results = session.query(PlayerGame.Player.Name, PlayerGame.Game.Week, PlayerGame.).all()

# #     session.close()

# #     # Create a dictionary from the row data and append to a list of all players
# #     all_players = []
# #     for name, position_id in results:
# #         player_dict = {}
# #         player_dict["name"] = name
# #         player_dict["position"] = position_id
# #         all_players.append(player_dict)

# #     return jsonify(all_players)

# TODO: Create route for player stats
@app.route("/api/player_stats/<name>")
# @app.route("/api/v1.0/temp/<start>/<end>")
def player_stats(name=None):
    # # Select statement
    # sel = [func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)]

    # if not end:
    #     # calculate TMIN, TAVG, TMAX for dates greater than start
    #     results = session.query(*sel).\
    #         filter(Measurement.date >= start).all()
    #     # Unravel results into a 1D array and convert to a list
    #     temps = list(np.ravel(results))
    #     return jsonify(temps)

    # # calculate TMIN, TAVG, TMAX with start and stop
    # results = session.query(*sel).\
    #     filter(Measurement.date >= start).\
    #     filter(Measurement.date <= end).all()
    # # Unravel results into a 1D array and convert to a list
    # temps = list(np.ravel(results))

    # Create our session (link) from Python to the DB
    session = Session(engine)
    if name == "":
        return "Player stat search requires a player name."
    
    searchname = name
    searchstring = f"%{searchname}%"
    results = session.query(Player).filter(Player.name.ilike(searchstring))

    session.close()

    # Create a dictionary from the row data and append to a list of all players
    all_player_stats = []
    for player in results:
        player_stats_dict = {}
        player_stats_dict["name"] = player.name
        player_stats_dict["position"] = player.position.position_name
        player_games = []
        for pg in player.player_game_collection:
            game_dict = {}
            game_dict["week"] = pg.game.week
            game_dict["dk_salary"] = pg.dk_salary
            game_dict["fd_salary"] = pg.fd_salary
            game_dict["dk_points"] = pg.dk_points
            game_dict["fd_points"] = pg.fd_points
            player_games.append(game_dict)
        player_stats_dict["games"] = player_games

        all_player_stats.append(player_stats_dict)

    return jsonify(all_player_stats)



if __name__ == '__main__':
    app.run(debug=True)
