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


def format_records(records):
    result = {}
    result['EventID'] = records[0].get('event_id')
    result['Attendance'] = []
    result['AttendanceStateName'] = {}
    for record in records:
        entry = {
            "MemberID": record.get("member_id"),
            "AttendanceStateID": record.get("attendance_state_id"),
            "AttendanceStateName":{"EN": record.get("attendance_state_name_en"), "AR": record.get("attendance_state_name_ar")},
        }
        result['Attendance'].append(entry)
    return result


def lambda_handler(event, context):
    conn, response = connect()

    if conn is not None:
        with conn as conn:
            try:
                cursor = conn.cursor()
                event_id = event.get("pathParameters").get("eventID")
                args = [event_id]
                cursor.callproc("GetEvent", args)
                eventRecord = cursor.fetchone()
                if eventRecord is not None:
                    cursor.callproc("GetEventAttendance", args)
                    records = cursor.fetchall()
                    if len(records) == 0:
                        response = {
                            "isBase64Encoded": False,
                            "statusCode": 404,
                            "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                            "body": json.dumps({"message": "Attendance not found"}),
                        }
                    else:
                        data = format_records(records)
                        response = {
                            "isBase64Encoded": False,
                            "statusCode": 200,
                            "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                            "body": json.dumps(data, default=str),
                        }
                else:
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 404,
                        "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                        "body": json.dumps({"message": "Event not found"}),
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
            insert_log(cursor, event, response, "GetEventAttendance")
            conn.commit()

    return response
if __name__ == "__main__":
    import dotenv
    import uuid
    import time
    dotenv.load_dotenv()
    event = {
        "pathParameters": {
            "eventID": "23",
        },
        "requestContext": {
            "requestId": uuid.uuid4(),
            "requestTimeEpoch": time.time() * 1000,
        },
    }
    context = None
    print(lambda_handler(event, context))