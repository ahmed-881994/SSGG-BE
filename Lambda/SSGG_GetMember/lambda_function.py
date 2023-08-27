import json
import os
import pymysql.cursors


def connect():
    try:
        # connect to database
        # reading the database parameters from the config object
        response = None
        cursor = pymysql.cursors.DictCursor
        conn = pymysql.connect(
            host=os.environ.get("host"),
            database=os.environ.get("database"),
            user=os.environ.get("username"),
            password=os.environ.get("password"),
            cursorclass=cursor,
        )
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
            #params= json.loads(event["pathParameters"])
            memberID = event['pathParameters']['memberID']
            cursor.callproc("GetMember", [memberID])
            records = cursor.fetchone()
            if records is not None:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 200,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps(records, default=str),
                }
            else:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 404,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": "Member not found"}),
                }
    return response
