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
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": error.args[1]}),
        }
    return conn, response


def format_record(records):
    entry = {
        "TeamID": records[0]['team_id'],
        "TeamName": {
            "EN": records[0]['team_name_en'],
            "AR": records[0]['team_name_ar']
        },
        "StageID": records[0]['stage_id'],
        "StageName": {
            "EN": records[0]['stage_name_en'],
            "AR": records[0]['stage_name_ar']
        },
        "Leaders": [],
        "Members": []
    }

    for record in records:
        if record['member_id'] is None:
            continue
        member_entry = {
            "MemberID": record['member_id'],
            "Name": {
                "EN": record['name_en'],
                "AR": record['name_ar']
            }
        }

        if record['is_leader'] == 1:
            entry['Leaders'].append(member_entry)
        else:
            entry['Members'].append(member_entry)

    return entry


def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                teamID = event['pathParameters']['teamID']
                cursor.callproc("GetTeamMembers", [teamID])
                records = cursor.fetchall()

                if len(records) > 0:
                    data = format_record(records)
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 200,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps(data, default=str),
                    }
                else:
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 404,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps({"message": "Team has no members or teamID is not correct"}),
                    }
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": error.args[1]}),
                }
            
            insert_log(cursor, event, response, "GetTeamMembers")
            conn.commit()

    return response
