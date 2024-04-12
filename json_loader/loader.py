import psycopg
import json
import os

import compinput
import lineupinput
import matchinput
import eventinput

dbName = "project_database"
password = "1234"
host = "localhost"
port = "5432"


def reset_database(cursor, conn):
    cursor.execute("DELETE FROM event_type")
    cursor.execute("DELETE FROM freeze_frame")
    cursor.execute("DELETE FROM event_object")
    cursor.execute("DELETE FROM event_type_obj")
    cursor.execute("DELETE FROM event")
    cursor.execute("DELETE FROM game_match")
    cursor.execute("DELETE FROM player_position")
    cursor.execute("DELETE FROM play_pattern")
    cursor.execute("DELETE FROM manager")
    cursor.execute("DELETE FROM team")
    cursor.execute("DELETE FROM player")
    cursor.execute("DELETE FROM referee")
    cursor.execute("DELETE FROM stadium")
    cursor.execute("DELETE FROM competition_stage")
    cursor.execute("DELETE FROM competition")
    cursor.execute("DELETE FROM position_type")
    cursor.execute("DELETE FROM lineup")
    cursor.execute("DELETE FROM country")
    conn.commit()

def input_play_pattern(cursor, conn):
    fcPattern = open('play_pattern.json')
    patternData = json.load(fcPattern)

    for i in patternData:
        patternId = i['id']
        patternName = i['name']
        try:
            cursor.execute("INSERT INTO play_pattern (pattern_id, pattern_name) VALUES (%s, %s);", (patternId, patternName))
            conn.commit()
        except Exception as error:
            print(error)

def input_comp_stages(cursor, conn):
    fcStages = open('competition_stages.json')
    competitionStagesData = json.load(fcStages)

    for i in competitionStagesData:
        stageId = i['stage_id']
        stageName = i['stage_name']
        try:
            cursor.execute("INSERT INTO competition_stage (stage_id, stage_name) VALUES (%s, %s);", (stageId, stageName))
            conn.commit()
        except Exception as error:
            print(error)

def input_position_types(cursor, conn):
    fcPosTypes = open('position_types.json')
    posTypesData = json.load(fcPosTypes)

    for i in posTypesData:
        typeId = i['position_id']
        typeName = i['position_name']
        try:
            cursor.execute("INSERT INTO position_type (type_id, type_name) VALUES (%s, %s);", (typeId, typeName))
            conn.commit()
        except Exception as error:
            print(error)


def input_countries(cursor, conn):
    fcCountryTypes = open('countries.json')
    countryTypesData = json.load(fcCountryTypes)

    for i in countryTypesData:
        countryId = i['country_id']
        countryName = i['country_name']
        try:
            cursor.execute("INSERT INTO country (country_id, country_name) VALUES (%s, %s);", (countryId, countryName))
            conn.commit()
        except Exception as error:
            print(error)

def input_event_types(cursor, conn):
    fcEventObject = open('event_types.json')
    eventObjectData = json.load(fcEventObject)

    for i in eventObjectData:
        objectId = i['type_id']
        objectName = i['type_name']
        try:
            cursor.execute("INSERT INTO event_type_obj (type_id, type_name) VALUES (%s, %s);", (objectId, objectName))
            conn.commit()
        except Exception as error:
            print(error)



conn = psycopg.connect(dbname=dbName, user="postgres", password=password, host=host, port=port)
cursor = conn.cursor()
reset_database(cursor, conn)
input_comp_stages(cursor, conn)
input_position_types(cursor, conn)
input_countries(cursor, conn)
input_event_types(cursor, conn)
input_play_pattern(cursor, conn)
compinput.competition_input(cursor, conn)
matchinput.matches(cursor, conn)
lineupinput.lineups(cursor, conn)
eventinput.events(cursor, conn)







