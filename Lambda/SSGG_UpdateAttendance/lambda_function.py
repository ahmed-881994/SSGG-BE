import json
import pymysql.cursors


def connect():
    try:
        # connect to database
        # reading the database parameters from the config object
        response = None
        cursor = pymysql.cursors.DictCursor
        conn = pymysql.connect(
            host="localhost",
            port=3306,
            database="ssgg",
            user="a.safwat",
            password="P@ssw0rd",
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
                    body = json.loads(event["body"])
                    attendanceList = body.get("Attendance")
                    success_flag = True
                    for attendance in attendanceList:
                        memberID = attendance.get("MemberID")
                        attendanceState = attendance.get("AttendanceState")
                        cursor.callproc("GetMember", [memberID])
                        member = cursor.fetchone()
                        if member is not None:
                            cursor.callproc(
                                "UpdateAttendance", [memberID, eventID, attendanceState]
                            )
                        else:
                            success_flag=False
                            conn.rollback()
                            response = {
                                "isBase64Encoded": False,
                                "statusCode": 404,
                                "headers": {"Content-Type": "application/json"},
                                "body": json.dumps({"message": "Member not found"}),
                            }
                            break
                    if success_flag:
                        conn.commit()
                        response = {
                            "isBase64Encoded": False,
                            "statusCode": 200,
                            "headers": {"Content-Type": "application/json"},
                            "body": json.dumps({"message": "Event attendance updated"}),
                        }
                # if event does not exist
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