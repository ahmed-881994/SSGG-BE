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
            memberID = event['pathParameters']['memberID']
            cursor.callproc("GetMember", [memberID])
            records = cursor.fetchone()
            if records is not None:
                data={}
                data['MemberID']=records['member_id']
                names={}
                names['EN']=records['name_en']
                names['AR']=records['name_ar']
                data['Name']= names
                team_name={}
                team_name['EN']=records['team_name_en']
                team_name['AR']=records['team_name_ar']
                data['TeamName']= team_name
                data['PlaceOfBirth']=records['place_of_birth']
                data['DateOfBirth']=records['date_of_birth']
                data['Address']=records['address']
                data['NationalIdNo']=records['national_id_no']
                data['ClubIdNo']=records['club_id_no']
                data['PassportNo']=records['passport_no']
                data['DateJoined']=records['date_joined']
                data['MobileNo']=records['mobile_number']
                data['HomeContact']=records['home_contact']
                data['Email']=records['email']
                data['FacebookURL']=records['facebook_url']
                data['SchoolName']=records['school_name']
                data['EducationType']=records['education_type']
                data['FatherName']=records['father_name']
                data['FatherContact']=records['father_contact']
                data['FatherJob']=records['father_job']
                data['MotherName']=records['mother_name']
                data['MotherContact']=records['mother_contact']
                data['MotherJob']=records['mother_job']
                data['GuardianName']=records['guardian_name']
                data['GuardianContact']=records['guardian_contact']
                data['GuardianRelationship']=records['guardian_relationship']
                data['Hobbies']=records['hobbies']
                data['HealthIssues']=records['health_issues']
                data['Medications']=records['medications']
                data['QRCodeURL']=records['qr_code_url']
                data['ImageURL']=records['image_url']
                data['NationalIdURL']=records['national_id_url']
                data['ParentNationalIdURL']=records['parent_national_id_url']
                data['ClubIdURL']=records['club_id_url']
                data['PassportURL']=records['passport_url']
                data['BirthCertificateURL']=records['birth_certificate_url']
                data['PhotoConsent']=records['photo_consent']
                data['ConditionsConsent']=records['conditions_consent']
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
