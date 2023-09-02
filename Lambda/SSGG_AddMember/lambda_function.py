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

def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            data = event["body"]
            args = [
                data["MemberID"],
                data["Name"]["EN"],
                data["Name"]["AR"],
                data["PlaceOfBirth"],
                data["DateOfBirth"],
                data["Address"],
                str(data["NationalIdNo"]),
                str(data["ClubIdNo"]),
                data["PassportNo"],
                data["DateJoined"],
                data["MobileNo"],
                data["HomeContact"],
                data["Email"],
                data["FacebookURL"],
                data["SchoolName"],
                data["EducationType"],
                data["FatherName"],
                data["FatherContact"],
                data["FatherJob"],
                data["MotherName"],
                data["MotherContact"],
                data["MotherJob"],
                data["GuardianName"],
                data["GuardianContact"],
                data["GuardianRelationship"],
                data["Hobbies"],
                data["HealthIssues"],
                data["Medications"],
                data["QRCodeURL"],
                data["ImageURL"],
                data["NationalIdURL"],
                data["ParentNationalIdURL"],
                data["ClubIdURL"],
                data["PassportURL"],
                data["BirthCertificateURL"],
                data["PhotoConsent"],
                data["ConditionsConsent"],
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