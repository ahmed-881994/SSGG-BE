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


def lambda_handler(event, context):
    conn, response = connect()

    if conn is not None:
        with conn as conn:
            try:
                cursor = conn.cursor()
                # check event exists
                eventID = event.get("pathParameters").get("eventID")
                cursor.callproc("GetEvent", [eventID])
                eventRecord = cursor.fetchone()
                # if event exists
                if eventRecord is not None:
                    body = json.loads(event["body"])
                    attendanceList = body.get("Attendance")
                    success_flag = True
                    for attendance in attendanceList:
                        memberID = attendance.get("MemberID")
                        attendanceState = attendance.get("AttendanceStateID")
                        cursor.callproc("GetMember", [memberID])
                        member = cursor.fetchone()
                        if member is not None:
                            cursor.callproc(
                                "TakeAttendance", [
                                    memberID, eventID, attendanceState]
                            )
                        else:
                            success_flag = False
                            conn.rollback()
                            response = {
                                "isBase64Encoded": False,
                                "statusCode": 404,
                                "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                                "body": json.dumps({"message": "Member " + memberID + " not found"}),
                            }
                            break
                    if success_flag:
                        conn.commit()
                        response = {
                            "isBase64Encoded": False,
                            "statusCode": 200,
                            "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                            "body": json.dumps({"message": "Attendance taken"}),
                        }
                # if event does not exist
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
            finally:
                insert_log(cursor, event, response, "TakeAttendance")
                conn.commit()
    return response
