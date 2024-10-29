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

    if response is None:
        with conn.cursor() as cursor:
            try:
                body = json.loads(event["body"])
                memberID = body.get("Member").get("MemberID")
                teamID = event['pathParameters']['teamID']
                cursor.callproc("GetMember", [memberID])
                records = cursor.fetchone()
                if records is not None:
                    if records.get('team_id') == teamID:
                        response = {
                            "isBase64Encoded": False,
                            "statusCode": 400,
                            "headers": {"Content-Type": "application/json",
                                        'Access-Control-Allow-Headers': '*',
                                        'Access-Control-Allow-Origin': '*',
                                        'Access-Control-Allow-Methods': '*'},
                            "body": json.dumps({"message": "Member already belongs to team"}),
                        }
                    else:
                        is_leader = 1 if body.get("IsLeader") == True else 0
                        from_date = body.get("FromDate")
                        args = [
                            memberID,
                            teamID,
                            from_date,
                            is_leader
                        ]
                        cursor.callproc("AddMemberToTeam", args)
                        conn.commit()
                        response = {
                            "isBase64Encoded": False,
                            "statusCode": 201,
                            "headers": {"Content-Type": "application/json",
                                        'Access-Control-Allow-Headers': '*',
                                        'Access-Control-Allow-Origin': '*',
                                        'Access-Control-Allow-Methods': '*'},
                            "body": json.dumps(
                                {"message": "Member added to team"}
                            ),
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

    return response
