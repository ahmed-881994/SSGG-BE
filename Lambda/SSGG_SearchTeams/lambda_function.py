from datetime import datetime
import json
import os
import pymysql.cursors
from collections import defaultdict

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
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": error.args}),
        }
    return conn, response


def format_records(records):
    teams = defaultdict(lambda: {
        "TeamID": None,
        "TeamName": {"EN": "", "AR": ""},
        "StageID": None,
        "StageName": {"EN": "", "AR": ""},
        "Leaders": [],
        "Members": []
    })

    for entry in records:
        team_id = entry.get('team_id')
        if teams[team_id]["TeamID"] is None:
            teams[team_id]["TeamID"] = team_id
            teams[team_id]["TeamName"]["EN"] = entry.get('team_name_en')
            teams[team_id]["TeamName"]["AR"] = entry.get('team_name_ar')
            teams[team_id]["StageID"] = entry.get('stage_id')
            teams[team_id]["StageName"]["EN"] = entry.get('stage_name_en')
            teams[team_id]["StageName"]["AR"] = entry.get('stage_name_ar')

        member = {
            "MemberID": entry.get('member_id'),
            "Name": {
                "EN": entry.get('name_en'),
                "AR": entry.get('name_ar')
            }
        }

        if entry.get('is_leader'):
            teams[team_id]["Leaders"].append(member)
        else:
            teams[team_id]["Members"].append(member)

    return list(teams.values())


def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                queryParams = event.get("queryStringParameters")
                teamName = queryParams.get("teamName")
                stageID = queryParams.get("stageID")
                leaderID = queryParams.get("leaderID")
                cursor.callproc("SearchTeams", [stageID, leaderID, teamName])
                records = cursor.fetchall()

                if records:
                    data = format_records(records)
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
                        "body": json.dumps({"message": "Team not found"}),
                    }
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": error.args}),
                }
            insert_log(cursor, event, response, "GetMember")
            conn.commit()

    return response
