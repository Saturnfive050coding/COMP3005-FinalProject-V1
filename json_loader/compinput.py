import psycopg
import json

def competition_input(cursor, conn):
    with open('competitions.json', 'r') as f:
        compData = json.loads(f.read())
    columns = "("
    rows = "("
    first = True

    for i in compData:
        #print(i)
        first = True
        for key, value in i.items():
            if value:
                if not first:
                    columns += ", "
                    rows += ", "
                first = False
                columns += key
                if isinstance(value, str):
                    rows += "'" + value + "'"
                else:
                    rows += str(value)
        columns += ")"
        rows += ")"
        cursor.execute("INSERT INTO competition " + columns + " VALUES " + rows + ";")
        conn.commit()
        columns = "("
        rows = "("