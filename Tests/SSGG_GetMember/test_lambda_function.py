import json
import time
import uuid
import pytest
import datetime
from unittest.mock import patch, ANY
import sys
import os

# Add the path to Lambda/SSGG_GetMember to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../Lambda/SSGG_GetMember')))

from Lambda.SSGG_GetMember.lambda_function import connect, insert_log, format_records, lambda_handler


# Mock environment variables
@pytest.fixture
def mock_env():
    with patch.dict('os.environ', {
        "host": "mock_host",
        "port": "3306",
        "database": "mock_db",
        "username": "mock_user",
        "password": "mock_pass",
    }):
        yield


def test_connect_success(mock_env):
    with patch("pymysql.connect") as mock_connect:
        conn, response = connect()
        assert conn is not None
        assert response is None
        mock_connect.assert_called_once()


def test_connect_failure(mock_env):
    with patch("pymysql.connect", side_effect=Exception("Connection failed")):
        conn, response = connect()
        assert conn is None
        assert response["statusCode"] == 500
        assert "Connection failed" in response["body"]


def test_format_records():
    records = [{'team_id': 1, 'team_name_en': 'Bagera', 'team_name_ar': 'باجيرا', 'is_leader': 0, 'team_join_date': datetime.date(2023, 9, 14), 'team_transfer_date': datetime.date(2024, 1, 4), 'member_id': 's123', 'name_en': 'Test User', 'name_ar': 'test user', 'place_of_birth': 'Alexandria', 'date_of_birth': datetime.date(1994, 8, 8), 'address': 'string', 'national_id_no': '0', 'club_id_no': '0', 'passport_no': 'string', 'date_joined': datetime.date(2003, 9, 1), 'mobile_number': 'string', 'home_contact': 'string', 'email': 'user@example.com', 'facebook_url': 'string', 'school_name': 'string', 'education_type': 'string', 'father_name': 'string', 'father_contact': 'string', 'father_job': 'string', 'mother_name': 'string', 'mother_contact': 'string', 'mother_job': 'string', 'guardian_name': 'string', 'guardian_contact': 'string', 'guardian_relationship': 'string', 'hobbies': 'string', 'health_issues': 'string', 'medications': 'string', 'qr_code_url': 'string', 'image_url': 'string', 'national_id_url': 'string', 'parent_national_id_url': 'string', 'club_id_url': 'string', 'passport_url': 'string', 'birth_certificate_url': 'string', 'photo_consent': 0, 'conditions_consent': 0}, {'team_id': 2, 'team_name_en': 'Raksha', 'team_name_ar': 'راكشا', 'is_leader': 0, 'team_join_date': datetime.date(2024, 1, 4), 'team_transfer_date': None, 'member_id': 's123', 'name_en': 'Test User', 'name_ar': 'test user', 'place_of_birth': 'Alexandria', 'date_of_birth': datetime.date(1994, 8, 8), 'address': 'string', 'national_id_no': '0', 'club_id_no': '0', 'passport_no': 'string', 'date_joined': datetime.date(2003, 9, 1), 'mobile_number': 'string', 'home_contact': 'string', 'email': 'user@example.com', 'facebook_url': 'string', 'school_name': 'string', 'education_type': 'string', 'father_name': 'string', 'father_contact': 'string', 'father_job': 'string', 'mother_name': 'string', 'mother_contact': 'string', 'mother_job': 'string', 'guardian_name': 'string', 'guardian_contact': 'string', 'guardian_relationship': 'string', 'hobbies': 'string', 'health_issues': 'string', 'medications': 'string', 'qr_code_url': 'string', 'image_url': 'string', 'national_id_url': 'string', 'parent_national_id_url': 'string', 'club_id_url': 'string', 'passport_url': 'string', 'birth_certificate_url': 'string', 'photo_consent': 0, 'conditions_consent': 0}, {'team_id': 7, 'team_name_en': 'Advanced Scouts', 'team_name_ar': 'المتقدم', 'is_leader': 1, 'team_join_date': datetime.date(2023, 9, 4), 'team_transfer_date': None, 'member_id': 's123', 'name_en': 'Test User', 'name_ar': 'test user', 'place_of_birth': 'Alexandria', 'date_of_birth': datetime.date(1994, 8, 8), 'address': 'string', 'national_id_no': '0', 'club_id_no': '0', 'passport_no': 'string', 'date_joined': datetime.date(2003, 9, 1), 'mobile_number': 'string', 'home_contact': 'string', 'email': 'user@example.com', 'facebook_url': 'string', 'school_name': 'string', 'education_type': 'string', 'father_name': 'string', 'father_contact': 'string', 'father_job': 'string', 'mother_name': 'string', 'mother_contact': 'string', 'mother_job': 'string', 'guardian_name': 'string', 'guardian_contact': 'string', 'guardian_relationship': 'string', 'hobbies': 'string', 'health_issues': 'string', 'medications': 'string', 'qr_code_url': 'string', 'image_url': 'string', 'national_id_url': 'string', 'parent_national_id_url': 'string', 'club_id_url': 'string', 'passport_url': 'string', 'birth_certificate_url': 'string', 'photo_consent': 0, 'conditions_consent': 0}]
    formatted = format_records(records)
    assert formatted["MemberID"] == 's123'
    assert formatted["Name"]["EN"] == "Test User"
    assert len(formatted["Teams"]) == 3


def test_lambda_handler_success(mock_env):
    mock_event = {
        "pathParameters": {"memberID": "s123"},
        "requestContext": {"requestTimeEpoch": 1700000000000},
    }
    with patch("pymysql.connect") as mock_conn:
        mock_cursor = mock_conn.cursor.return_value.__enter__.return_value
        mock_cursor.fetchall.return_value = [{'team_id': 1, 'team_name_en': 'Bagera', 'team_name_ar': 'باجيرا', 'is_leader': 0, 'team_join_date': datetime.date(2023, 9, 14), 'team_transfer_date': datetime.date(2024, 1, 4), 'member_id': 's123', 'name_en': 'Test User', 'name_ar': 'test user', 'place_of_birth': 'Alexandria', 'date_of_birth': datetime.date(1994, 8, 8), 'address': 'string', 'national_id_no': '0', 'club_id_no': '0', 'passport_no': 'string', 'date_joined': datetime.date(2003, 9, 1), 'mobile_number': 'string', 'home_contact': 'string', 'email': 'user@example.com', 'facebook_url': 'string', 'school_name': 'string', 'education_type': 'string', 'father_name': 'string', 'father_contact': 'string', 'father_job': 'string', 'mother_name': 'string', 'mother_contact': 'string', 'mother_job': 'string', 'guardian_name': 'string', 'guardian_contact': 'string', 'guardian_relationship': 'string', 'hobbies': 'string', 'health_issues': 'string', 'medications': 'string', 'qr_code_url': 'string', 'image_url': 'string', 'national_id_url': 'string', 'parent_national_id_url': 'string', 'club_id_url': 'string', 'passport_url': 'string', 'birth_certificate_url': 'string', 'photo_consent': 0, 'conditions_consent': 0}, {'team_id': 2, 'team_name_en': 'Raksha', 'team_name_ar': 'راكشا', 'is_leader': 0, 'team_join_date': datetime.date(2024, 1, 4), 'team_transfer_date': None, 'member_id': 's123', 'name_en': 'Test User', 'name_ar': 'test user', 'place_of_birth': 'Alexandria', 'date_of_birth': datetime.date(1994, 8, 8), 'address': 'string', 'national_id_no': '0', 'club_id_no': '0', 'passport_no': 'string', 'date_joined': datetime.date(2003, 9, 1), 'mobile_number': 'string', 'home_contact': 'string', 'email': 'user@example.com', 'facebook_url': 'string', 'school_name': 'string', 'education_type': 'string', 'father_name': 'string', 'father_contact': 'string', 'father_job': 'string', 'mother_name': 'string', 'mother_contact': 'string', 'mother_job': 'string', 'guardian_name': 'string', 'guardian_contact': 'string', 'guardian_relationship': 'string', 'hobbies': 'string', 'health_issues': 'string', 'medications': 'string', 'qr_code_url': 'string', 'image_url': 'string', 'national_id_url': 'string', 'parent_national_id_url': 'string', 'club_id_url': 'string', 'passport_url': 'string', 'birth_certificate_url': 'string', 'photo_consent': 0, 'conditions_consent': 0}, {'team_id': 7, 'team_name_en': 'Advanced Scouts', 'team_name_ar': 'المتقدم', 'is_leader': 1, 'team_join_date': datetime.date(2023, 9, 4), 'team_transfer_date': None, 'member_id': 's123', 'name_en': 'Test User', 'name_ar': 'test user', 'place_of_birth': 'Alexandria', 'date_of_birth': datetime.date(1994, 8, 8), 'address': 'string', 'national_id_no': '0', 'club_id_no': '0', 'passport_no': 'string', 'date_joined': datetime.date(2003, 9, 1), 'mobile_number': 'string', 'home_contact': 'string', 'email': 'user@example.com', 'facebook_url': 'string', 'school_name': 'string', 'education_type': 'string', 'father_name': 'string', 'father_contact': 'string', 'father_job': 'string', 'mother_name': 'string', 'mother_contact': 'string', 'mother_job': 'string', 'guardian_name': 'string', 'guardian_contact': 'string', 'guardian_relationship': 'string', 'hobbies': 'string', 'health_issues': 'string', 'medications': 'string', 'qr_code_url': 'string', 'image_url': 'string', 'national_id_url': 'string', 'parent_national_id_url': 'string', 'club_id_url': 'string', 'passport_url': 'string', 'birth_certificate_url': 'string', 'photo_consent': 0, 'conditions_consent': 0}]

        with patch("lambda_function.connect", return_value=(mock_conn, None)):
            with patch("lambda_function.insert_log"):
                response = lambda_handler(mock_event, None)
                assert response["statusCode"] == 200
                

def test_lambda_handler_not_found(mock_env):
    mock_event = {
        "pathParameters": {"memberID": "xxx"},
        "requestContext": {"requestTimeEpoch": 1700000000000},
    }
    with patch("pymysql.connect") as mock_conn:
        mock_cursor = mock_conn.cursor.return_value.__enter__.return_value
        mock_cursor.fetchall.return_value = None

        with patch("lambda_function.connect", return_value=(mock_conn, None)):
            with patch("lambda_function.insert_log"):
                response = lambda_handler(mock_event, None)
                assert response["statusCode"] == 404


def test_lambda_handler_failure(mock_env):
    mock_event = {
        "pathParameters": {
            "memberID": "s123",
        },
        "requestContext": {
            "requestId": uuid.uuid4(),
            "requestTimeEpoch": time.time() * 1000,
        },
    }
    
    with patch("lambda_function.connect", return_value=(None, {"statusCode": 500})):
        response = lambda_handler(mock_event, None)
        assert response["statusCode"] == 500

def test_insert_log_success(mock_env):
    mock_event = {
        "requestContext": {
            "requestId": "mock_request_id",
            "requestTimeEpoch": 1700000000000,
        },
        "queryStringParameters": {"param1": "value1"},
        "pathParameters": {"memberID": "s123"},
        "body": '{"key": "value"}',
    }
    mock_response = {
        "statusCode": 200,
        "body": '{"message": "Success"}',
    }

    mock_cursor = patch("pymysql.cursors.DictCursor").start()
    insert_log(mock_cursor, mock_event, mock_response, "GetMember")
    mock_cursor.callproc.assert_called_once_with(
        "InsertLogs",
        [
            "mock_request_id",
            "GetMember",
            json.dumps({
                "queryStringParameters": {"param1": "value1"},
                "pathParameters": {"memberID": "s123"},
                "body": '{"key": "value"}',
            }),
            "2023-11-15 00:13:20.000",
            json.dumps(mock_response),
            ANY,
            200,
            "Success",
        ],
    )


def test_insert_log_failure(mock_env):
    mock_event = {
        "requestContext": {
            "requestId": "mock_request_id",
            "requestTimeEpoch": 1700000000000,
        },
        "queryStringParameters": {"param1": "value1"},
        "pathParameters": {"memberID": "s123"},
        "body": '{"key": "value"}',
    }
    mock_response = {
        "statusCode": 500,
        "body": '{"message": "Internal Server Error"}',
    }
    mock_cursor = patch("pymysql.cursors.DictCursor").start()
    insert_log(mock_cursor, mock_event, mock_response, "GetMember")
    mock_cursor.callproc.assert_called_once_with(
        "InsertLogs",
        [
            "mock_request_id",
            "GetMember",
            json.dumps({
                "queryStringParameters": {"param1": "value1"},
                "pathParameters": {"memberID": "s123"},
                "body": '{"key": "value"}',
            }),
            "2023-11-15 00:13:20.000",
            json.dumps(mock_response),
            ANY,
            500,
            '{"message": "Internal Server Error"}',
        ],
    )

