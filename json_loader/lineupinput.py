import psycopg
import json

from os import listdir
from os.path import isfile, join

from pathlib import Path

def player_input(cursor, conn, player, team_id):
    columns = "("
    rows = "("
    first = True
    cursor.execute(f"SELECT player_id FROM player WHERE player_id = {str(player['player_id'])} AND team_id = {team_id};")
    if not cursor.fetchone():
        for key, value in player.items():
            if value:
                if key != "cards" and key != "positions":
                    if not first:
                            columns += ", "
                            rows += ", "
                    first = False
                    if key == "country":
                        columns += "country_id"
                        rows += str(value['id'])
                        cursor.execute(f"SELECT country_id FROM country WHERE country_id = {str(value['id'])};")
                        if not cursor.fetchone():
                            try:
                                value['name'] = value['name'].replace("'", "''")
                                cursor.execute("INSERT INTO country (country_id, country_name) VALUES (" + str(value['id']) + f", '{value['name']}');")
                                conn.commit()
                            except Exception as error:
                                print(error)
                    else:
                        columns += key
                        if isinstance(value, str):
                            
                            value = value.replace("'", "''")
                            #print(value)
                            rows += "'" + value + "'"
                        else:
                            rows += str(value)
        columns += ", team_id"
        rows += ", " + str(team_id)
        columns += ")"
        rows += ")"
        cursor.execute("INSERT INTO player " + columns + " VALUES " + rows + ";")
        conn.commit()

def position_input(cursor, conn, positions, player_id, match_id):
    columns = "("
    rows = "("
    first = True
    for i in positions:
        for key, value in i.items():
            if value and key != "position":
                if not first:
                        columns += ", "
                        rows += ", "
                first = False
                if key == "position_id":
                    columns += "pos"
                    rows += str(value)
                elif key == "from":
                    columns += "from_time"
                    rows += "'" + value + "'"
                elif key == "to":
                    columns += "to_time"
                    rows += "'" + value + "'"
                else:
                    columns += key
                    if isinstance(value, str):
                        rows += "'" + value + "'"
                    else:
                        rows += str(value)
        first = True
        columns += ", player_id, match_id"
        rows += ", " + str(player_id) + ", " + str(match_id)
        columns += ")"
        rows += ")"
        cursor.execute("INSERT INTO player_position " + columns + " VALUES " + rows + ";")
        conn.commit()
        columns = "("
        rows = "("

def input_lineup(cursor, conn, lineup, match_id):
    with open(lineup, 'r') as f:
        lineupData = json.loads(f.read())

    cursor.execute(f"SELECT season_id FROM game_match WHERE match_id = {match_id}")
    season_id = cursor.fetchone()
    #print(season_id)
    columns = "(season_id, "
    rows = f"({season_id[0]}, "
    team_id = 0
    for i in lineupData:
        for key, value in i.items():
            if key == "team_id":
                columns += key + ", "
                rows += str(value) + ", "
                team_id = value
            if key == "team_name":
                columns += key + ")"
                rows += "'" + value + "')"
                try:
                    cursor.execute("INSERT INTO lineup " + columns + " VALUES " + rows + ";")
                    conn.commit()
                except Exception as error:
                    print(error)
            if key == "lineup":
                #print(value)
                for j in value:
                    print(j['player_name'])
                    player_input(cursor, conn, j, team_id)
                    position_input(cursor, conn, j['positions'], j['player_id'], match_id)
        columns = "(season_id, "
        rows = f"({season_id[0]}, "

def lineups(cursor, conn):

    filenames = [f for f in listdir('lineups') if isfile(join('lineups', f))]

    for i in filenames:
        match_id = int(Path("lineups/"+i).stem)
        print(match_id)
        input_lineup(cursor, conn, 'lineups/'+i, match_id)