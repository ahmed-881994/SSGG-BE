import json
import os
import pymysql.cursors


def connect():
    try:
        # Connect to the database
        cursor = pymysql.cursors.DictCursor
        conn = pymysql.connect(
            host=os.environ.get("host"),
            port=int(os.environ.get("port")),
            database=os.environ.get("database"),
            user=os.environ.get("username"),
            password=os.environ.get("password"),
            cursorclass=cursor,
        )
        response = None
    except Exception as error:
        print(error)
        conn = None
        response = {
            "isBase64Encoded": False,
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "Couldn't reach the database"}),
        }
    return conn, response


def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                body = json.loads(event.get("body"))
                memberID = body.get("Member").get("MemberID")
                isLeader = body.get("Member").get("IsLeader")
                fromTeamID = body.get("FromTeamID")
                toTeamID = body.get("ToTeamID")
                transferDate = body.get("TransferDate")
                cursor.callproc("GetMember", [memberID])
                records = cursor.fetchone()
                if records is not None:
                    if records.get("team_id") == toTeamID:
                        response = {
                            "isBase64Encoded": False,
                            "statusCode": 400,
                            "headers": {"Content-Type": "application/json"},
                            "body": json.dumps(
                                {"message": "Member already belongs to team"}
                            ),
                        }
                    else:
                        cursor.callproc(
                            "TransferTeamMember",
                            [memberID, fromTeamID, toTeamID, transferDate, isLeader],
                        )
                        conn.commit()
                        response = {
                            "isBase64Encoded": False,
                            "statusCode": 201,
                            "headers": {"Content-Type": "application/json"},
                            "body": json.dumps({"message": "Member transferred"}),
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
                    "body": json.dumps({"message": error.args}),
                }

    return response