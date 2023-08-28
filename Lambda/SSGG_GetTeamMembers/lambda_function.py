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

def format_record(record):
    entry = {
        "TeamID": record['team_id'],
        "TeamName": {
            "EN": record['team_name_en'],
            "AR": record['team_name_ar']
        },
        "StageName": {
            "EN": record['stage_name_en'],
            "AR": record['stage_name_ar']
        },
        "Leaders": [],
        "Members": []
    }

    for record in record:
        member_entry = {
            "MemberID": record['member_id'],
            "Name": {
                "EN": record['name_en'],
                "AR": record['name_ar']
            }
        }

        if record['is_leader']:
            entry['Leaders'].append(member_entry)
        else:
            entry['Members'].append(member_entry)

    return entry

def lambda_handler(event, context):
    conn, response = connect()
    
    if response is None:
        with conn.cursor() as cursor:
            queryParams = event["queryStringParameters"]
            teamID = queryParams.get('teamID')
            name = queryParams.get('name')
            cursor.callproc("SearchMembers", [teamID, name])
            records = cursor.fetchall()
            
            if records is not None:
                data = [format_record(record) for record in records]
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
                    "body": json.dumps({"message": "Member not found"}),
                }
    
    return response
