import json
import os
import pymysql.cursors


def connect():
    try:
        # connect to database
        # reading the database parameters from the config object
        response = None
        cursor = pymysql.cursors.DictCursor
        conn = pymysql.connect(
            host=os.environ.get("host"),
            port=int(os.environ.get("port")),
            database=os.environ.get("database"),
            user=os.environ.get("username"),
            password=os.environ.get("password"),
            cursorclass=cursor,
        )
    except Exception as error:
        conn = None
        response = {
            "isBase64Encoded": False,
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": error.args}),
        }
    return conn, response


def format_records(records):
    formatted_entries = []

    for record in records:
        entry = {
            "EventID": record.get("event_id"),
            "EventTypeID": record.get("event_type_id"),
            "Name": {
                "EN": record.get("event_name_en"),
                "AR": record.get("event_name_ar"),
            },
            "Location": record.get("event_location"),
            "StartDate": record.get("event_start_date"),
            "EndDate": record.get("event_end_date"),
            "IsMultiTeam": record.get("is_multi_team"),
            "TeamID": record.get("team_id"),
        }
        formatted_entries.append(entry)

    return formatted_entries


def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                queryParams = event.get("queryStringParameters")
                teamID = queryParams.get("teamID")
                name = queryParams.get("name")
                startDate = queryParams.get("startDate")
                endDate = queryParams.get("endDate")
                cursor.callproc("SearchEvents", [teamID, name, startDate, endDate])
                records = cursor.fetchall()

                if records:
                    data = format_records(records)
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 200,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps(data, default=str),
                    }
                else:
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 404,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps({"message": "Event not found"}),
                    }
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": error.args}),
                }

    return response