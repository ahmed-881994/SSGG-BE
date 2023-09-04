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
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": error.args[1]}),
        }
    return conn, response

def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            data = event.get("body")
            args = [
                data.get("MemberID"),
                data.get("Name").get("EN"),
                data.get("Name").get("AR"),
                data.get("PlaceOfBirth"),
                data.get("DateOfBirth"),
                data.get("Address"),
                str(data.get("NationalIdNo")),
                str(data.get("ClubIdNo")),
                data.get("PassportNo"),
                data.get("DateJoined"),
                data.get("MobileNo"),
                data.get("HomeContact"),
                data.get("Email"),
                data.get("FacebookURL"),
                data.get("SchoolName"),
                data.get("EducationType"),
                data.get("FatherName"),
                data.get("FatherContact"),
                data.get("FatherJob"),
                data.get("MotherName"),
                data.get("MotherContact"),
                data.get("MotherJob"),
                data.get("GuardianName"),
                data.get("GuardianContact"),
                data.get("GuardianRelationship"),
                data.get("Hobbies"),
                data.get("HealthIssues"),
                data.get("Medications"),
                data.get("QRCodeURL"),
                data.get("ImageURL"),
                data.get("NationalIdURL"),
                data.get("ParentNationalIdURL"),
                data.get("ClubIdURL"),
                data.get("PassportURL"),
                data.get("BirthCertificateURL"),
                data.get("PhotoConsent"),
                data.get("ConditionsConsent"),
            ]
            try:
                cursor.callproc("AddMember", args)
                conn.commit()
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 201,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps(
                        {"message": "Member added", "MemberDetails": data}
                    ),
                }
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": error.args[1]}),
                }

    return response