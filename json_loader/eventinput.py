import psycopg
import json

from os import listdir
from os.path import isfile, join

from pathlib import Path

def input_freeze_frame(cursor, conn, freeze_frames, event_id):
    columns = "(event_id"
    rows = f"('{event_id}'"


    for i in freeze_frames:
        for key, value in i.items():
            columns += ", "
            rows += ", "
            if key == "location":
                columns += "frame_location"
                rows += f"'{value}'"
            elif key == "player":
                columns += "player_id"
                rows += f"{value['id']}"
            elif key == "position":
                columns += "position_id"
                rows += f"{value['id']}"
            else:
                columns += f"{key}"
                rows += f"'{value}'"
        columns += ")"
        rows += ")"
        cursor.execute("INSERT INTO freeze_frame " + columns + " VALUES " + rows + ";")
        conn.commit()
        columns = "(event_id"
        rows = f"('{event_id}'"

def input_new_outcomes(cursor, conn, outcome):
    cursor.execute(f"SELECT * FROM event_object WHERE object_id = {outcome['id']}")
    if not cursor.fetchone():
        columns = "(object_id, object_name)"
        rows = f"({outcome['id']}, '{outcome['name']}')"
        cursor.execute("INSERT INTO event_object " + columns + " VALUES " + rows + ";")
        conn.commit()


def input_event_type(cursor, conn, type, event_id, type_name):
    columns = "(event_id, type_name"
    rows = f"('{event_id}', '{type_name}'"
    first = True

    for key, value in type.items():
        if value:
            columns += ", "
            rows += ", "
            if key == "end_location":
                columns += key
                rows += f"'{value}'"
            elif key == "outcome":
                columns += "outcome_id"
                rows += f"{value['id']}"
                input_new_outcomes(cursor, conn, value)
            elif key == "card":
                columns += "card_id"
                rows += f"{value['id']}"
                input_new_outcomes(cursor, conn, value)
            elif key == "body_part":
                columns += "body_part_id"
                rows += f"{value['id']}"
                input_new_outcomes(cursor, conn, value)
            elif key == "type":
                columns += "type_id"
                rows += f"{value['id']}"
                input_new_outcomes(cursor, conn, value)
            elif key == "technique":
                columns += "technique_id"
                rows += f"{value['id']}"
                input_new_outcomes(cursor, conn, value)
            elif key == "position":
                columns += "position_id"
                rows += f"{value['id']}"
                input_new_outcomes(cursor, conn, value)
            elif key == "height":
                columns += "height_id"
                rows += f"{value['id']}"
                input_new_outcomes(cursor, conn, value)
            elif key == "key_pass":
                columns += "key_pass_id"
                rows += f"{value['id']}"
                input_new_outcomes(cursor, conn, value)
            elif key == "recipient":
                columns += "recipient_id"
                rows += f"{value['id']}"
            elif key == "replacement":
                columns += "replacement_id"
                rows += f"{value['id']}"
            elif key == "length":
                columns += "pass_length"
                rows += f"{value}"
            elif key == "cross":
                columns += "pass_cross"
                rows += f"{value}"
            elif key == "freeze_frame":
                input_freeze_frame(cursor, conn, value, event_id)
                columns = columns[:-2]
                rows = rows[:-2]
            else:
                columns += key
                if isinstance(value, str):
                    rows += "'" + value + "'"
                else:
                    rows += str(value)
    columns += ")"
    rows += ")"
    cursor.execute("INSERT INTO event_type " + columns + " VALUES " + rows + ";")
    conn.commit()




def input_events(cursor, conn, events, match_id):
    with open(events, 'r') as f:
        eventsData = json.loads(f.read())

    cursor.execute(f"SELECT season_id FROM game_match WHERE match_id = {match_id}")
    season_id = cursor.fetchone()
    #print(season_id)
    columns = "(season_id, match_id, "
    rows = f"({season_id[0]}, {match_id}, "
    first = True

    event_type = None

    for i in eventsData:
        first = True
        event_id = ""
        for key, value in i.items():
            if value:
                if not first:
                    columns += ", "
                    rows += ", "
                first = False
                if key == "id":
                    columns += "event_id"
                    rows += f"'{value}'"
                    event_id = value
                elif key == "index":
                    columns += "event_index"
                    rows += f"{value}"
                elif key == "period":
                    columns += "event_period"
                    rows += f"{value}"
                elif key == "timestamp":
                    columns += "time_stamp"
                    rows += f"'{value}'"
                elif key == "minute":
                    columns += "time_minute"
                    rows += f"{value}"
                elif key == "second":
                    columns += "time_second"
                    rows += f"{value}"
                elif key == "type":
                    columns += "type_id"
                    rows += f"'{value['id']}'"
                    cursor.execute(f"SELECT type_name FROM event_type_obj WHERE type_id = {value['id']};")
                    event_type = cursor.fetchone()[0].lower()
                    event_type = event_type.replace(" ", "_")
                    event_type = event_type.replace("*", "")
                    event_type = event_type.replace("/", "_")
                elif key == "possession_team":
                    columns += "posession_team"
                    rows += f"'{value['id']}'"
                elif key == "play_pattern":
                    columns += "pattern_id"
                    rows += f"'{value['id']}'"
                elif key == "team":
                    columns += "team_id"
                    rows += f"'{value['id']}'"
                elif key == "player":
                    columns += "player_id"
                    rows += f"'{value['id']}'"
                elif key == "position":
                    columns += "position_id"
                    rows += f"'{value['id']}'"
                elif key == "tactics":
                    columns += "tactic_formation"
                    rows += f"'{value['formation']}'"
                elif key == "related_events":
                    columns += key
                    valueString = str(value)
                    valueString = valueString.replace("'", "''")
                    rows += f"'{valueString}'"
                elif key == "location":
                    columns += "event_location"
                    rows += f"'{value}'"
                elif key == event_type:
                    columns = columns[:-2]
                    rows = rows[:-2]
                    input_event_type(cursor, conn, value, event_id, event_type)
                else:
                    columns += key
                    if isinstance(value, str):
                        rows += "'" + value + "'"
                    else:
                        rows += str(value)
        columns += ")"
        rows += ")"
        cursor.execute("INSERT INTO event " + columns + " VALUES " + rows + ";")
        conn.commit()
        columns = "(season_id, match_id, "
        rows = f"({season_id[0]}, {match_id}, "


def events(cursor, conn):

    filenames = [f for f in listdir('events') if isfile(join('events', f))]

    for i in filenames:
        match_id = int(Path("events/"+i).stem)
        input_events(cursor, conn, 'events/'+i, match_id)