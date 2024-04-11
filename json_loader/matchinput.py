import psycopg
import json

from os import listdir
from os.path import isfile, join

def home_team_input(cursor, conn, team):
    cursor.execute(f"SELECT * FROM team WHERE team_id = {team['home_team_id']}")
    if not cursor.fetchone():
        columns = "("
        rows = "("

        columns += "team_id, "
        rows += str(team['home_team_id']) + ", "

        columns += "team_name, "
        rows += "'" + team['home_team_name'] + "', "

        columns += "team_gender, "
        rows += "'" + team['home_team_gender'] + "', "

        if(team['home_team_group']):
            columns += "team_group, "
            rows += "'" + team['home_team_group'] + "', "
        
        columns += "country_id)"
        rows += str(team['country']['id']) + ")"

        cursor.execute("INSERT INTO team " + columns + " VALUES " + rows + ";")
        conn.commit()


def away_team_input(cursor, conn, team):
    cursor.execute(f"SELECT * FROM team WHERE team_id = {team['away_team_id']}")
    if not cursor.fetchone():
        columns = "("
        rows = "("

        columns += "team_id, "
        rows += str(team['away_team_id']) + ", "

        columns += "team_name, "
        rows += "'" + team['away_team_name'] + "', "

        columns += "team_gender, "
        rows += "'" + team['away_team_gender'] + "', "

        if(team['away_team_group']):
            columns += "team_group, "
            rows += "'" + team['away_team_group'] + "', "
        
        columns += "country_id)"
        rows += str(team['country']['id']) + ")"

        cursor.execute("INSERT INTO team " + columns + " VALUES " + rows + ";")
        conn.commit()

def manager_input(cursor, conn, team_id, managers):
    columns = "("
    rows = "("
    first = True

    for i in managers:
        #print(i)
        first = True
        cursor.execute(f"SELECT * FROM manager WHERE manager_id = {i['id']}")
        if not cursor.fetchone():
            for key, value in i.items():
                if value:
                    if not first:
                        columns += ", "
                        rows += ", "
                    first = False
                    if key == "id": columns += "manager_id"
                    elif key == "name": columns += "manager_name"
                    elif key == "nickname": columns += "manager_nickname"
                    elif key == "dob": columns += "manager_dob"
                    elif key == "country":
                        columns += "country_id"
                        rows += str(value['id'])
                        cursor.execute(f"SELECT country_id FROM country WHERE country_id = {value['id']};")
                        if not cursor.fetchone():
                            try:
                                cursor.execute("INSERT INTO country (country_id, country_name) VALUES (" + str(value['id']) + f", '{value['name']}');")
                                conn.commit()
                            except Exception as error:
                                print(error)
                    else:
                        columns += key
                    if isinstance(value, str):
                        rows += "'" + value + "'"
                    elif key != "country":
                        rows += str(value)
            columns += ", team_id"
            rows += ", " + str(team_id)
            columns += ")"
            rows += ")"
            cursor.execute("INSERT INTO manager " + columns + " VALUES " + rows + ";")
            conn.commit()
            columns = "("
            rows = "("


def stadium_input(cursor, conn, stadium):
    cursor.execute(f"SELECT * FROM stadium WHERE stadium_id = {stadium['id']}")
    if not cursor.fetchone():
        columns = "("
        rows = "("

        columns += "stadium_id, "
        rows += str(stadium['id']) + ", "
        
        columns += "stadium_name, "
        rows += "'" + stadium['name'] + "', "

        columns += "country_id)"
        rows += str(stadium['country']['id']) + ")"

        cursor.execute("INSERT INTO stadium " + columns + " VALUES " + rows + ";")
        conn.commit()

def referee_input(cursor, conn, referee):
    cursor.execute(f"SELECT * FROM referee WHERE referee_id = {referee['id']}")
    if not cursor.fetchone():
        columns = "("
        rows = "("

        columns += "referee_id, "
        rows += str(referee['id']) + ", "
        
        columns += "referree_name, "
        rows += "'" + referee['name'] + "', "

        columns += "country_id)"
        rows += str(referee['country']['id']) + ")"

        cursor.execute(f"SELECT country_id FROM country WHERE country_id = {referee['country']['id']};")
        if not cursor.fetchone():
            try:
                cursor.execute("INSERT INTO country (country_id, country_name) VALUES (" + str(referee['country']['id']) + f", '{referee['country']['name']}');")
                conn.commit()
            except Exception as error:
                print(error)

        cursor.execute("INSERT INTO referee " + columns + " VALUES " + rows + ";")
        conn.commit()

def match_input(cursor, conn, match):
    columns = "("
    rows = "("
    first = True
    with open(match, 'r') as f:
        matchData = json.loads(f.read())
    

    for i in matchData:
        for key, value in i.items():
            if key != "metadata":
                if value:
                    if not first:
                        columns += ", "
                        rows += ", "
                    first = False
                    if key == "competition":
                        columns += "competition_id"
                        rows += str(value['competition_id'])
                    elif key == "season":
                        columns += "season_id"
                        rows += str(value['season_id'])
                    elif key == "home_team":
                        columns += "home_team_id"
                        rows += str(value['home_team_id'])
                        home_team_input(cursor, conn, value)
                        if len(value) > 5:
                            manager_input(cursor, conn, value['home_team_id'], value['managers'])
                    elif key == "away_team":
                        columns += "away_team_id"
                        rows += str(value['away_team_id'])
                        away_team_input(cursor, conn, value)
                        if len(value) > 5:
                            manager_input(cursor, conn, value['away_team_id'], value['managers'])
                    elif key == "competition_stage":
                        columns += "competition_stage_id"
                        rows += str(value['id'])
                    elif key == "stadium":
                        columns += "stadium_id"
                        rows += str(value['id'])
                        stadium_input(cursor, conn, value)
                    elif key == "referee" and value:
                        columns += "referee_id"
                        rows += str(value['id'])
                        referee_input(cursor, conn, value)
                    else:
                        columns += key
                        if isinstance(value, str):
                            rows += "'" + value + "'"
                        else:
                            rows += str(value)
        columns += ")"
        rows += ")"
        cursor.execute("INSERT INTO game_match " + columns + " VALUES " + rows + ";")
        conn.commit()
        columns = "("
        rows = "("
        first = True

def matches(cursor, conn):

    filenames = [f for f in listdir('matches') if isfile(join('matches', f))]

    for i in filenames:
        match_input(cursor, conn, 'matches/'+i)