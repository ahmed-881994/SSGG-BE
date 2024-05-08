

def lambda_handler(event, context):
    response = {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"}
    }

    return response
