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
            "body": json.dumps({"message": error.args[1]}),
        }
    return conn, response


def lambda_handler(event, context):
    conn, response = connect()
    if response is None:
        with conn.cursor() as cursor:
            try:
                cursor.execute("SELECT * FROM lookups")
                tables = cursor.fetchall()
                if tables:
                    data = []
                    for table in tables:
                        record = {}
                        table_name = table.get("table_name")
                        record['TableName'] = table_name
                        record['Description'] = table.get("description")
                        cursor.execute(f"SELECT {table_name[:-1] + '_id'}, {table_name[:-1]+'_name_ar'}, {
                                       table_name[:-1]+'_name_en'} FROM ssgg.{table_name}")

                        records = cursor.fetchall()
                        # pprint(records)
                        if records:
                            record['LookupValues'] = []
                            for record_ in records:
                                record_entry = {
                                    "LookupID": record_.get(table_name[:-1]+"_id"),
                                    "AR": record_.get(table_name[:-1] + "_name_ar"),
                                    "EN": record_.get(table_name[:-1] + "_name_en"),
                                }
                                record['LookupValues'].append(record_entry)
                        # pprint(records)
                        data.append(record)
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 200,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps(data),
                    }
                else:
                    response = {
                        "isBase64Encoded": False,
                        "statusCode": 404,
                        "headers": {"Content-Type": "application/json"},
                        "body": json.dumps({"message": "No data found"}),
                    }
            except Exception as error:
                response = {
                    "isBase64Encoded": False,
                    "statusCode": 500,
                    "headers": {"Content-Type": "application/json"},
                    "body": json.dumps({"message": error.args[1]}),
                }
