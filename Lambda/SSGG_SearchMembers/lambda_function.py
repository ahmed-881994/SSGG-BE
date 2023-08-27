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
            queryParams=event["queryStringParameters"]
            if queryParams.has_key('teamID'):
                teamID = queryParams['teamID']
            else:
                teamID=None
            if queryParams.has_key('name'):
                name = queryParams['name']
            else:
                name=None
            cursor.callproc("SearchMembers", [teamID,name])
            records = cursor.fetchall()
            if records is not None:
                data=[]
                for record in records:
                    for entry in data:
                        entry['MemberID']=record['member_id']
                        names={}
                        names['EN']=record['name_en']
                        names['AR']=record['name_ar']
                        entry['Name']= names
                        team_name={}
                        team_name['EN']=record['team_name_en']
                        team_name['AR']=record['team_name_ar']
                        entry['TeamName']= team_name
                        entry['PlaceOfBirth']=record['place_of_birth']
                        entry['DateOfBirth']=record['date_of_birth']
                        entry['Address']=record['address']
                        entry['NationalIdNo']=record['national_id_no']
                        entry['ClubIdNo']=record['club_id_no']
                        entry['PassportNo']=record['passport_no']
                        entry['DateJoined']=record['date_joined']
                        entry['MobileNo']=record['mobile_number']
                        entry['HomeContact']=record['home_contact']
                        entry['Email']=record['email']
                        entry['FacebookURL']=record['facebook_url']
                        entry['SchoolName']=record['school_name']
                        entry['EducationType']=record['education_type']
                        entry['FatherName']=record['father_name']
                        entry['FatherContact']=record['father_contact']
                        entry['FatherJob']=record['father_job']
                        entry['MotherName']=record['mother_name']
                        entry['MotherContact']=record['mother_contact']
                        entry['MotherJob']=record['mother_job']
                        entry['GuardianName']=record['guardian_name']
                        entry['GuardianContact']=record['guardian_contact']
                        entry['GuardianRelationship']=record['guardian_relationship']
                        entry['Hobbies']=record['hobbies']
                        entry['HealthIssues']=record['health_issues']
                        entry['Medications']=record['medications']
                        entry['QRCodeURL']=record['qr_code_url']
                        entry['ImageURL']=record['image_url']
                        entry['NationalIdURL']=record['national_id_url']
                        entry['ParentNationalIdURL']=record['parent_national_id_url']
                        entry['ClubIdURL']=record['club_id_url']
                        entry['PassportURL']=record['passport_url']
                        entry['BirthCertificateURL']=record['birth_certificate_url']
                        entry['PhotoConsent']=record['photo_consent']
                        entry['ConditionsConsent']=record['conditions_consent']
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
    return response
