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
                    body.get("PhotoConsent"),
                    body.get("ConditionsConsent"),
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

    return response
