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
        # connect to database
        # reading the database parameters from the config object
        response = None
        cursor = pymysql.cursors.DictCursor
        conn = pymysql.connect(
            host=os.environ.get("host"),
            port=int(os.environ["port"]),
            database=os.environ["database"],
            user=os.environ["username"],
            password=os.environ["password"],
            cursorclass=cursor,
        )
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
                # check event exists
                memberID = event.get("pathParameters").get("memberID")
                cursor.callproc("GetMember", [memberID])
                memberRecord = cursor.fetchone()
                # if event exists
                if memberRecord is not None:
                    body = json.loads(event.get("body"))
                    args = []
                    args.append(memberID)
                    args.append(body.get("Name").get("EN") if body.get(
                        "Name", {}).get("EN") else memberRecord.get("name_en"))
                    args.append(body.get("Name").get("AR") if body.get(
                        "Name", {}).get("AR") else memberRecord.get("name_ar"))
                    args.append(body.get("PlaceOfBirth") if body.get(
                        "PlaceOfBirth") else memberRecord.get("place_of_birth"))
                    args.append(body.get("DateOfBirth") if body.get(
                        "DateOfBirth") else memberRecord.get("date_of_birth"))
                    args.append(body.get("Address") if body.get(
                        "Address") else memberRecord.get("address"))
                    args.append(body.get("NationalIdNo") if body.get(
                        "NationalIdNo") else memberRecord.get("national_id_no"))
                    args.append(body.get("ClubIdNo") if body.get(
                        "ClubIdNo") else memberRecord.get("club_id_no"))
                    args.append(body.get("PassportNo") if body.get(
                        "PassportNo") else memberRecord.get("passport_no"))
                    args.append(body.get("DateJoined") if body.get(
                        "DateJoined") else memberRecord.get("date_joined"))
                    args.append(body.get("MobileNo") if body.get(
                        "MobileNo") else memberRecord.get("mobile_number"))
                    args.append(body.get("HomeContact") if body.get(
                        "HomeContact") else memberRecord.get("home_contact"))
                    args.append(body.get("Email") if body.get(
                        "Email") else memberRecord.get("email"))
                    args.append(body.get("FacebookURL") if body.get(
                        "FacebookURL") else memberRecord.get("facebook_url"))
                    args.append(body.get("SchoolName") if body.get(
                        "SchoolName") else memberRecord.get("school_name"))
                    args.append(body.get("EducationType") if body.get(
                        "EducationType") else memberRecord.get("education_type"))
                    args.append(body.get("FatherName") if body.get(
                        "FatherName") else memberRecord.get("father_name"))
                    args.append(body.get("FatherContact") if body.get(
                        "FatherContact") else memberRecord.get("father_contact"))
                    args.append(body.get("FatherJob") if body.get(
                        "FatherJob") else memberRecord.get("father_job"))
                    args.append(body.get("MotherName") if body.get(
                        "MotherName") else memberRecord.get("mother_name"))
                    args.append(body.get("MotherContact") if body.get(
                        "MotherContact") else memberRecord.get("mother_contact"))
                    args.append(body.get("MotherJob") if body.get(
                        "MotherJob") else memberRecord.get("mother_job"))
                    args.append(body.get("GuardianName") if body.get(
                        "GuardianName") else memberRecord.get("guardian_name"))
                    args.append(body.get("GuardianContact") if body.get(
                        "GuardianContact") else memberRecord.get("guardian_contact"))
                    args.append(body.get("GuardianRelationship") if body.get(
                        "GuardianRelationship") else memberRecord.get("guardian_relationship"))
                    args.append(body.get("Hobbies") if body.get(
                        "Hobbies") else memberRecord.get("hobbies"))
                    args.append(body.get("HealthIssues") if body.get(
                        "HealthIssues") else memberRecord.get("health_issues"))
                    args.append(body.get("Medications") if body.get(
                        "Medications") else memberRecord.get("medications"))
                    args.append(body.get("QRCodeURL") if body.get(
                        "QRCodeURL") else memberRecord.get("qr_code_url"))
                    args.append(body.get("ImageURL") if body.get(
                        "ImageURL") else memberRecord.get("image_url"))
                    args.append(body.get("NationalIdURL") if body.get(
                        "NationalIdURL") else memberRecord.get("national_id_url"))
                    args.append(body.get("ParentNationalIdURL") if body.get(
                        "ParentNationalIdURL") else memberRecord.get("parent_national_id_url"))
                    args.append(body.get("ClubIdURL") if body.get(
                        "ClubIdURL") else memberRecord.get("club_id_url"))
                    args.append(body.get("PassportURL") if body.get(
                        "PassportURL") else memberRecord.get("passport_url"))
                    args.append(body.get("BirthCertificateURL") if body.get(
                        "BirthCertificateURL") else memberRecord.get("birth_certificate_url"))
                    photoConsent = body.get("PhotoConsent") if body.get(
                        "PhotoConsent") else memberRecord.get("photo_consent")
                    args.append(
                        1 if photoConsent == True else 0
                    )
                    conditionsConsent = body.get("ConditionsConsent") if body.get(
                        "ConditionsConsent") else memberRecord.get("conditions_consent")
                    args.append(
                        1 if conditionsConsent == True else 0
                    )
                    cursor.callproc("UpdateMember", args)
                    conn.commit()
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 200,
                        "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                        "body": json.dumps({"message": "Member updated"}),
                    }
                else:
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 404,
                        "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                        "body": json.dumps({"message": "Member not found"}),
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
            finally:
                insert_log(cursor, event, response, "UpdateMember")
                conn.commit()
    return response
