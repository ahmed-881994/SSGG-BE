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


def format_records(record):
    entry = {
        "EventID": record.get("event_id"),
        "EventName": {
            "EN": record.get("event_name_en"),
            "AR": record.get("event_name_ar"),
        },
        "EventLocation": record.get("event_location"),
        "EventStartDate": record.get("event_start_date"),
        "EventEndDate": record.get("event_end_date"),
        "IsMultiTeam": record.get("is_multi_team"),
        "TeamID": record.get("team_id"),
    }
    return entry


def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                body = json.loads(event.get("body"))
                args = []
                args.append(body.get("EventTypeID"))
                args.append(body.get("EventName").get("EN"))
                args.append(body.get("EventName").get("AR"))
                args.append(body.get("EventLocation"))
                args.append(body.get("EventStartDate"))
                args.append(body.get("EventEndDate"))
                args.append(1 if body.get("IsMultiTeam") == True else 0)
                args.append(body.get("TeamID"))
                
                cursor.callproc("CreateEvent", args)
                conn.commit()
                records = cursor.fetchone()
                if records:
                    args = [records.get("event_id")]
                    cursor.callproc("GetEvent", args)
                    records = cursor.fetchone()
                    data = format_records(records)
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 201,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps(data, default=str),
                    }
                else:
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 500,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps({"message": "Error executing request"}),
                    }
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": error.args}),
                }

    return response