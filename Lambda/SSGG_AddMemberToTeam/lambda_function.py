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
        # Connect to the database
        cursor = pymysql.cursors.DictCursor
        conn = pymysql.connect(
            host=os.environ.get("host"),
            port=int(os.environ["port"]),
            database=os.environ["database"],
            user=os.environ["username"],
            password=os.environ["password"],
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

    if conn is not None:
        with conn as conn:
            try:
                cursor = conn.cursor()
                body = json.loads(event["body"])
                memberID = body.get("MemberID")
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
            finally:
                insert_log(cursor, event, response, "AddMemberToTeam")
                conn.commit()

    return response

if __name__ == "__main__":
    import dotenv
    import uuid
    import time
    dotenv.load_dotenv()
    event = {
        "pathParameters": {
            "teamID": "1",
        },
        "body": """{
                    "MemberID": "S413-02028",
                    "IsLeader": true,
                    "FromDate": "2025-03-14"
                    }""",
        "requestContext": {
            "requestId": uuid.uuid4(),
            "requestTimeEpoch": time.time() * 1000,
        },
    }
    context = None
    print(lambda_handler(event, context))