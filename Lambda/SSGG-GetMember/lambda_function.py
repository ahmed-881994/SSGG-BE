import json
import os
import pymysql.cursors


def connect():
    try:
        # connect to database
        # reading the database parameters from the config object
        conn = pymysql.connect(
            host=os.environ.get("host"),
            database=os.environ.get("database"),
            user=os.environ.get("username"),
            password=os.environ.get("password")
            # cursorclass=pymysql.cursors.DictCursor
        )
        return conn
    except Exception as error:
        print(error)
        return {
            "isBase64Encoded": False,
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "Couldn't reach the database"}),
        }


def lambda_handler(event, context):
    # TODO implement
    conn= connect()
    cur = conn.cursor(pymysql.cursors.DictCursor) 
    args=[event["pathParameters"]["memberID"]]
    cur.callproc('GetMember',args)
    records = cur.fetchone()
    if records is not None:
        return {
            "isBase64Encoded": False,
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(records,default=str),
        }
    else:
        return {
            "isBase64Encoded": False,
            "statusCode": 404,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "Member not found"}),
        }
