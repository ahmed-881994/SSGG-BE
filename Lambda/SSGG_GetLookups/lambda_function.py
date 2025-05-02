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
                cursor.execute(f"SELECT * FROM {os.environ.get('database')}.lookups")
                tables = cursor.fetchall()
                if tables:
                    data = []
                    for table in tables:
                        record = {}
                        table_name = table.get("table_name")
                        if table_name:
                            record['TableName'] = table_name
                            record['Description'] = table.get("description")
                            cursor.execute(f"SELECT {table_name[:-1] + '_id'}, {table_name[:-1]+'_name_ar'}, {table_name[:-1]+'_name_en'} FROM {os.environ.get('database')}.{table_name}")
                            records = cursor.fetchall()
                            print(records)
                            if records:
                                record['LookupValues'] = []
                                for record_ in records:
                                    record_entry = {
                                        "LookupID": record_.get(table_name[:-1]+"_id"),
                                        "AR": record_.get(table_name[:-1] + "_name_ar"),
                                        "EN": record_.get(table_name[:-1] + "_name_en"),
                                    }
                                    record['LookupValues'].append(record_entry)
                            data.append(record)
                        data.append(record)
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 200,
                        "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                        "body": json.dumps(data, default=str),
                    }
                else:
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 404,
                        "headers": {"Content-Type": "application/json",
                                    'Access-Control-Allow-Headers': '*',
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': '*'},
                        "body": json.dumps({"message": "No data found"}),
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
                insert_log(cursor, event, response, "GetLookups")
                conn.commit()
    return response

if __name__ == "__main__":
    import dotenv
    import uuid
    import time
    dotenv.load_dotenv()
    event = {
        "requestContext": {
            "requestId": uuid.uuid4(),
            "requestTimeEpoch": time.time() * 1000,
        },
    }
    context = None
    print(lambda_handler(event, context))