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
            "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
            "body": json.dumps({"message": error.args[1]}),
        }
    return conn, response


def format_records(records):
    result = []
    for record in records:
        entry={
            "EventID": record.get('event_id'),
            "EventNameEN": record.get('event_id'),
            "EventNameEN": record.get('event_name_en'),
            "EventNameAR": record.get('event_name_ar'),
            "EventStartDate": record.get("event_start_date"),
            "EventEndDate": record.get("event_end_date"),
            "EventTypeNameEN": record.get("event_type_name_en"),
            "EventTypeNameAR": record.get("event_type_name_ar"),
            "AttendanceStateNameEN": record.get("attendance_state_name_en"),
            "AttendanceStateNameAR": record.get("attendance_state_name_ar"),
        }
        result.append(entry)
    return result


def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                member_id = event.get("pathParameters").get("memberID")
                args = [member_id]
                cursor.callproc("GetMember", args)
                memberRecord = cursor.fetchone()
                if memberRecord:
                    cursor.callproc("GetMemberAttendance", args)
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
                        "body": json.dumps({"message": "Member not found"}),
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
            insert_log(cursor, event, response, "GetMemberAttendance")
            conn.commit()

    return response
if __name__ == "__main__":
    import dotenv
    import uuid
    import time
    dotenv.load_dotenv()
    event = {
        "pathParameters": {
            "memberID": "s123",
        },
        "requestContext": {
            "requestId": uuid.uuid4(),
            "requestTimeEpoch": time.time() * 1000,
        },
    }
    context = None
    print(lambda_handler(event, context))