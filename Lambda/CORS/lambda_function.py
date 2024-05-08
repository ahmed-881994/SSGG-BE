

def lambda_handler(event, context):
    response = {
        "isBase64Encoded": False,
        "statusCode": 201,
        "headers": {"Content-Type": "application/json"}
    }

    return response
