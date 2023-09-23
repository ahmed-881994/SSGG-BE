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

def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                # check event exists
                eventID = event.get("pathParameters").get("eventID")
                cursor.callproc("GetEvent", [eventID])
                eventRecord = cursor.fetchone()
                # if event exists
                if eventRecord is not None:
                    body = json.loads(event.get("body"))
                    args=[]
                    args.append(eventID)
                    args.append(body.get("EventTypeID"))
                    args.append(body.get("EventName").get("EN"))
                    args.append(body.get("EventName").get("AR"))
                    args.append(body.get("EventLocation"))
                    args.append(body.get("EventStartDate"))
                    args.append(body.get("EventEndDate"))
                    args.append(1 if body.get("IsMultiTeam") == True else 0)
                    args.append(body.get("TeamID"))
                    cursor.callproc("UpdateEvent", args)
                    conn.commit()
                    response = {
                            "isBase64Encoded": False,
                            "statusCode": 200,
                            "headers": {"Content-Type": "application/json"},
                            "body": json.dumps({"message": "Event updated"}),
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