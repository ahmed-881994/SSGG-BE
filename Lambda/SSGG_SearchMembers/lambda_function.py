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
    formatted_entries = []

    for record in records:
        member_id = record.get("member_id")

        # Check if an entry for this member already exists
        existing_entry = next(
            (
                entry
                for entry in formatted_entries
                if entry.get("MemberID") == member_id
            ),
            None,
        )

        if existing_entry:
            # Add team details to the existing entry's 'Teams' list
            team_entry = {
                "TeamID": record.get("team_id"),
                "IsTeamLeader": record.get("is_leader"),
                "TeamName": {
                    "EN": record.get("team_name_en"),
                    "AR": record.get("team_name_ar"),
                },
            }
            existing_entry.get("Teams").append(team_entry)
        else:
            # Create a new entry for this member
            entry = {
                "MemberID": member_id,
                "Name": {"EN": record.get("name_en"), "AR": record.get("name_ar")},
                "Teams": [
                    {
                        "TeamID": record.get("team_id"),
                        "IsTeamLeader": record.get("is_leader"),
                        "TeamName": {
                            "EN": record.get("team_name_en"),
                            "AR": record.get("team_name_ar"),
                        },
                    }
                ],
                "PlaceOfBirth": record.get("place_of_birth"),
                "DateOfBirth": record.get("date_of_birth"),
                "Address": record.get("address"),
                "NationalIdNo": record.get("national_id_no"),
                "ClubIdNo": record.get("club_id_no"),
                "PassportNo": record.get("passport_no"),
                "DateJoined": record.get("date_joined"),
                "MobileNo": record.get("mobile_number"),
                "HomeContact": record.get("home_contact"),
                "Email": record.get("email"),
                "FacebookURL": record.get("facebook_url"),
                "SchoolName": record.get("school_name"),
                "EducationType": record.get("education_type"),
                "FatherName": record.get("father_name"),
                "FatherContact": record.get("father_contact"),
                "FatherJob": record.get("father_job"),
                "MotherName": record.get("mother_name"),
                "MotherContact": record.get("mother_contact"),
                "MotherJob": record.get("mother_job"),
                "GuardianName": record.get("guardian_name"),
                "GuardianContact": record.get("guardian_contact"),
                "GuardianRelationship": record.get("guardian_relationship"),
                "Hobbies": record.get("hobbies"),
                "HealthIssues": record.get("health_issues"),
                "Medications": record.get("medications"),
                "QRCodeURL": record.get("qr_code_url"),
                "ImageURL": record.get("image_url"),
                "NationalIdURL": record.get("national_id_url"),
                "ParentNationalIdURL": record.get("parent_national_id_url"),
                "ClubIdURL": record.get("club_id_url"),
                "PassportURL": record.get("passport_url"),
                "BirthCertificateURL": record.get("birth_certificate_url"),
                "PhotoConsent": record.get("photo_consent"),
                "ConditionsConsent": record.get("conditions_consent"),
            }
            formatted_entries.append(entry)

    return formatted_entries


def lambda_handler(event, context):
    conn, response = connect()

    if response is None:
        with conn.cursor() as cursor:
            try:
                queryParams = event["queryStringParameters"]
                teamID = queryParams.get("teamID")
                name = queryParams.get("name")
                cursor.callproc("SearchMembers", [teamID, name])
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
