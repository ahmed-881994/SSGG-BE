from datetime import datetime
import json
import os
import pymysql.cursors

def insert_log(cursor, event, response, function_name):
    request_payload = response_payload = {}
    request_id = event.get('requestContext').get('requestId')
    request_payload['queryStringParameters'] = event.get("queryStringParameters")
    request_payload['pathParameters'] = event.get("pathParameters")
    request_payload['body'] = event.get("body")
    request_time = datetime.fromtimestamp(event.get('requestContext').get('requestTimeEpoch')/1000).strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    response_payload = response
    response_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    status_code = response.get("statusCode")
    error_message = response.get("body") if response.get("statusCode") != 200 else 'Success'
    cursor.callproc("InsertLogs", [request_id, function_name, json.dumps(request_payload), request_time, json.dumps(response_payload), response_time, status_code, error_message])
    return

def connect():
    try:
        # connect to database
        # reading the database parameters from the config object
        response = None
        cursor = pymysql.cursors.DictCursor
        conn = pymysql.connect(
            host=os.environ.get("host"),
            port=int(os.environ["port"]),
            database=os.environ["database"],
            user=os.environ["username"],
            password=os.environ["password"],
            cursorclass=cursor,
        )
    except Exception as error:
        conn = None
        response = {
            "isBase64Encoded": False,
            "statusCode": 500,
            "headers": {"Content-Type": "application/json",
                        'Access-Control-Allow-Headers': '*',
                        'Access-Control-Allow-Origin': '*',
                        'Access-Control-Allow-Methods': '*'},
            "body": json.dumps({"message": error.args[1]}),
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
        "IsMultiTeam": True if record.get("is_multi_team") == 1 else False,
        "TeamID": record.get("team_id"),
    }
    return entry


def lambda_handler(event, context):
    conn, response = connect()

    if conn is not None:
        with conn as conn:
            try:
                cursor = conn.cursor()
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
                event_record = cursor.fetchone()
                if event_record:
                    args=[]
                    args.append(body.get("TeamID"))
                    cursor.callproc("GetTeamMembers",args)
                    team_members = cursor.fetchall()
                    for member in team_members:
                        args=[]
                        args.append(member.get("member_id"))
                        args.append(event_record.get("event_id"))
                        args.append(5)
                        cursor.callproc("CreateAttendance",args)
                    conn.commit()
                    args = [event_record.get("event_id")]
                    cursor.callproc("GetEvent", args)
                    event_record = cursor.fetchone()
                    data = format_records(event_record)
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 201,
                        "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                        "body": json.dumps(data, default=str),
                    }
                else:
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 500,
                        "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                        "body": json.dumps({"message": "Error executing request"}),
                    }
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json",
                                'Access-Control-Allow-Headers': '*',
                                'Access-Control-Allow-Origin': '*',
                                'Access-Control-Allow-Methods': '*'},
                    "body": json.dumps({"message": error.args[1]}),
                }
            finally:
                insert_log(cursor, event, response, "CreateEvent")
                conn.commit()

    return response

if __name__ == "__main__":
    import dotenv
    import uuid
    import time
    dotenv.load_dotenv()
    event = {
        "body": """{
            "EventTypeID": 1,
            "EventName": {
                "EN": "string",
                "AR": "string"
            },
            "EventLocation": "string",
            "EventStartDate": "2025-03-12",
            "EventEndDate": "2025-03-12",
            "IsMultiTeam": true,
            "TeamID": 1
            }""",
        "requestContext": {
            "requestId": uuid.uuid4(),
            "requestTimeEpoch": time.time() * 1000,
        },
    }
    context = None
    print(lambda_handler(event, context))