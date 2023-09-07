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

def format_record(record):
    entry = {}
    entry['MemberID'] = record['member_id']
    
    field_mappings = {
        'Name': {'EN': 'name_en', 'AR': 'name_ar'},
        'TeamID': 'team_id',
        'TeamName': {'EN': 'team_name_en', 'AR': 'team_name_ar'},
        'PlaceOfBirth': 'place_of_birth',
        'DateOfBirth': 'date_of_birth',
        'Address': 'address',
        'NationalIdNo': 'national_id_no',
        'ClubIdNo': 'club_id_no',
        'PassportNo': 'passport_no',
        'DateJoined': 'date_joined',
        'MobileNo': 'mobile_number',
        'HomeContact': 'home_contact',
        'Email': 'email',
        'FacebookURL': 'facebook_url',
        'SchoolName': 'school_name',
        'EducationType': 'education_type',
        'FatherName': 'father_name',
        'FatherContact': 'father_contact',
        'FatherJob': 'father_job',
        'MotherName': 'mother_name',
        'MotherContact': 'mother_contact',
        'MotherJob': 'mother_job',
        'GuardianName': 'guardian_name',
        'GuardianContact': 'guardian_contact',
        'GuardianRelationship': 'guardian_relationship',
        'Hobbies': 'hobbies',
        'HealthIssues': 'health_issues',
        'Medications': 'medications',
        'QRCodeURL': 'qr_code_url',
        'ImageURL': 'image_url',
        'NationalIdURL': 'national_id_url',
        'ParentNationalIdURL': 'parent_national_id_url',
        'ClubIdURL': 'club_id_url',
        'PassportURL': 'passport_url',
        'BirthCertificateURL': 'birth_certificate_url',
        'PhotoConsent': 'photo_consent',
        'ConditionsConsent': 'conditions_consent'
    }
    
    for key, value in field_mappings.items():
        if isinstance(value, str):
            entry[key] = record[value]
        else:
            entry[key] = {
                lang: record[field] for lang, field in value.items()
            }
    
    return entry

def lambda_handler(event, context):
    conn, response = connect()
    
    if response is None:
        with conn.cursor() as cursor:
            try:
                queryParams = event["queryStringParameters"]
                teamID = queryParams.get('teamID') if queryParams.get('teamID') is not None else None
                name = queryParams.get('name') if queryParams.get('name') is not None else None
                cursor.callproc("SearchMembers", [teamID, name])
                records = cursor.fetchall()
                
                if records:
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
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": error.args[1]}),
                }
    
    return response
