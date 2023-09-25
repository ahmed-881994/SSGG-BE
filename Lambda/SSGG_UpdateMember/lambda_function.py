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


def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                # check event exists
                memberID = event.get("pathParameters").get("memberID")
                cursor.callproc("GetMember", [memberID])
                memberRecord = cursor.fetchone()
                # if event exists
                if memberRecord is not None:
                    body = json.loads(event.get("body"))
                    args = []
                    args.append(memberID)
                    args.append(body.get("Name").get("EN"))
                    args.append(body.get("Name").get("AR"))
                    args.append(body.get("PlaceOfBirth"))
                    args.append(body.get("DateOfBirth"))
                    args.append(body.get("Address"))
                    args.append(body.get("NationalIdNo"))
                    args.append(body.get("ClubIdNo"))
                    args.append(body.get("PassportNo"))
                    args.append(body.get("DateJoined"))
                    args.append(body.get("MobileNo"))
                    args.append(body.get("HomeContact"))
                    args.append(body.get("Email"))
                    args.append(body.get("FacebookURL"))
                    args.append(body.get("SchoolName"))
                    args.append(body.get("EducationType"))
                    args.append(body.get("FatherName"))
                    args.append(body.get("FatherContact"))
                    args.append(body.get("FatherContact"))
                    args.append(body.get("MotherName"))
                    args.append(body.get("MotherContact"))
                    args.append(body.get("MotherJob"))
                    args.append(body.get("GuardianName"))
                    args.append(body.get("GuardianContact"))
                    args.append(body.get("GuardianRelationship"))
                    args.append(body.get("Hobbies"))
                    args.append(body.get("HealthIssues"))
                    args.append(body.get("Medications"))
                    args.append(body.get("QRCodeURL"))
                    args.append(body.get("ImageURL"))
                    args.append(body.get("NationalIdURL"))
                    args.append(body.get("ParentNationalIdURL"))
                    args.append(body.get("ClubIdURL"))
                    args.append(body.get("PassportURL"))
                    args.append(body.get("BirthCertificateURL"))
                    args.append(
                        1 if body.get("PhotoConsent") == True else 0
                    )
                    args.append(
                        1 if body.get("ConditionsConsent") == True else 0
                    )
                    cursor.callproc("UpdateMember", args)
                    conn.commit()
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 200,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps({"message": "Member updated"}),
                    }
                else:
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 404,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps({"message": "Member not found"}),
                    }
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": error.args}),
                }
    return response