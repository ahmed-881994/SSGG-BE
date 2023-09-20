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
            "body": json.dumps({"message": error.args}),
        }
    return conn, response


def format_records(records):
    formatted_entry = {
        "MemberID": records[0].get("member_id"),
        "Name": {
            "EN": records[0].get("name_en"),
            "AR": records[0].get("name_ar"),
        },
        "Teams": [],
        "PlaceOfBirth": records[0].get("place_of_birth"),
        "DateOfBirth": records[0].get("date_of_birth"),
        "Address": records[0].get("address"),
        "NationalIdNo": records[0].get("national_id_no"),
        "ClubIdNo": records[0].get("club_id_no"),
        "PassportNo": records[0].get("passport_no"),
        "DateJoined": records[0].get("date_joined"),
        "MobileNo": records[0].get("mobile_number"),
        "HomeContact": records[0].get("home_contact"),
        "Email": records[0].get("email"),
        "FacebookURL": records[0].get("facebook_url"),
        "SchoolName": records[0].get("school_name"),
        "EducationType": records[0].get("education_type"),
        "FatherName": records[0].get("father_name"),
        "FatherContact": records[0].get("father_contact"),
        "FatherJob": records[0].get("father_job"),
        "MotherName": records[0].get("mother_name"),
        "MotherContact": records[0].get("mother_contact"),
        "MotherJob": records[0].get("mother_job"),
        "GuardianName": records[0].get("guardian_name"),
        "GuardianContact": records[0].get("guardian_contact"),
        "GuardianRelationship": records[0].get("guardian_relationship"),
        "Hobbies": records[0].get("hobbies"),
        "HealthIssues": records[0].get("health_issues"),
        "Medications": records[0].get("medications"),
        "QRCodeURL": records[0].get("qr_code_url"),
        "ImageURL": records[0].get("image_url"),
        "NationalIdURL": records[0].get("national_id_url"),
        "ParentNationalIdURL": records[0].get("parent_national_id_url"),
        "ClubIdURL": records[0].get("club_id_url"),
        "PassportURL": records[0].get("passport_url"),
        "BirthCertificateURL": records[0].get("birth_certificate_url"),
        "PhotoConsent": records[0].get("photo_consent"),
        "ConditionsConsent": records[0].get("conditions_consent"),
    }

    for record in records:
        team_entry = {
            "TeamID": record.get("team_id"),
            "IsTeamLeader": record.get("is_leader"),
            "TeamName": {
                "EN": record.get("team_name_en"),
                "AR": record.get("team_name_ar"),
            },
        }
        formatted_entry["Teams"].append(team_entry)

    return formatted_entry


def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                memberID = event["pathParameters"].get("memberID")
                cursor.callproc("GetMember", [memberID])
                records = cursor.fetchall()

                if records is not None:
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
