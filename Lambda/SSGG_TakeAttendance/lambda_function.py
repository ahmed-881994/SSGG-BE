import json
import os
import pymysql.cursors
from pprintpp import pprint

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
            "body": json.dumps({"message": error.args[1]}),
        }
    return conn, response

def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                eventID = event.get('pathParameters').get('eventID')
                memberID = event.get('body').get('MemberID')
                attendanceState= event.get('body').get('AttendanceState')
                cursor.callproc("GetMember", [memberID])
                member = cursor.fetchone()
                if member is not None:
                    cursor.callproc("GetEvent", [eventID])
                    eventRecord = cursor.fetchone()
                    if eventRecord is not None:
                        cursor.callproc("TakeAttendance", [memberID, eventID, attendanceState])
                        conn.commit()
                        response = {
                        "isBase64Encoded": False,
                        "statusCode": 200,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps({"message": "Attendance taken"}),
                    }
                    else:
                        response = {
                        "isBase64Encoded": False,
                        "statusCode": 404,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps({"message": "Event not found"}),
                    }
                else:
                        response = {
                        "isBase64Encoded": False,
                        "statusCode": 404,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps({"message": "Member not found"}),
                    }
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": error.args[1]}),
                }
    return response