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
                args = [
                    body.get("MemberID"),
                    body.get("Name").get("EN"),
                    body.get("Name").get("AR"),
                    body.get("PlaceOfBirth"),
                    body.get("DateOfBirth"),
                    body.get("Address"),
                    str(body.get("NationalIdNo")),
                    str(body.get("ClubIdNo")),
                    body.get("PassportNo"),
                    body.get("DateJoined"),
                    body.get("MobileNo"),
                    body.get("HomeContact"),
                    body.get("Email"),
                    body.get("FacebookURL"),
                    body.get("SchoolName"),
                    body.get("EducationType"),
                    body.get("FatherName"),
                    body.get("FatherContact"),
                    body.get("FatherJob"),
                    body.get("MotherName"),
                    body.get("MotherContact"),
                    body.get("MotherJob"),
                    body.get("GuardianName"),
                    body.get("GuardianContact"),
                    body.get("GuardianRelationship"),
                    body.get("Hobbies"),
                    body.get("HealthIssues"),
                    body.get("Medications"),
                    body.get("QRCodeURL"),
                    body.get("ImageURL"),
                    body.get("NationalIdURL"),
                    body.get("ParentNationalIdURL"),
                    body.get("ClubIdURL"),
                    body.get("PassportURL"),
                    body.get("BirthCertificateURL"),
                    1 if body.get("PhotoConsent") == True else 0,
                    1 if body.get("ConditionsConsent") == True else 0,
                ]
                cursor.callproc("AddMember", args)
                conn.commit()
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 201,
                    "headers": {"Content-Type": "application/json",
                                'Access-Control-Allow-Headers': '*',
                                'Access-Control-Allow-Origin': '*',
                                'Access-Control-Allow-Methods': '*'},
                    "body": json.dumps(
                        {"message": "Member added", "MemberDetails": body}
                    ),
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
                
            insert_log(cursor, event, response, "AddMember")
            conn.commit()

    return response
