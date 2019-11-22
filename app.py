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
    """List all available api routes."""
    return (
        f"Available Routes:<br/>"
        f"/api/v1.0/names<br/>"
        f"/api/v1.0/players"
        f"/api/v1.0/player_games"


    )


@app.route("/api/v1.0/names")
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


@app.route("/api/v1.0/players")
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

# TODO: Create route for player games
# @app.route("/api/v1.0/player_games")
# def players():
#     # Create our session (link) from Python to the DB
#     session = Session(engine)

#     """Return a list of passenger data including the name, age, and sex of each passenger"""
#     # Query all passengers
#     results = session.query(Player.name, Player.position_id).all()

#     session.close()

#     # Create a dictionary from the row data and append to a list of all players
#     all_players = []
#     for name, position_id in results:
#         player_dict = {}
#         player_dict["name"] = name
#         player_dict["position"] = position_id
#         all_players.append(player_dict)

#     return jsonify(all_players)


if __name__ == '__main__':
    app.run(debug=True)
