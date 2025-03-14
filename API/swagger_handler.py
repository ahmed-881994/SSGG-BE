import boto3
import json


client = boto3.client('apigateway')

response = client.get_export(
    restApiId='bqxf5y910f',
    stageName='stg',
    exportType='oas30',
    parameters={
        'extensions':'authorizers'
    },
    accepts='application/json'
)

# Read the stream to get the raw bytes
body_bytes = response['body'].read()

# Convert bytes to string (if necessary, usually UTF-8)
body_str = body_bytes.decode('utf-8')

# Parse the JSON content into a Python dictionary
parsed_content = json.loads(body_str)

# Remove the default authorizer 
parsed_content['components']['securitySchemes'].pop('SSGG-Authorizer-STG')

# construct new authorizer object 
cognito={
    'type': 'oauth2',
    'x-tokenName': 'id_token',
    'flows':{
        'authorizationCode':{
            'authorizationUrl': 'https://ssgg-dev.auth.eu-north-1.amazoncognito.com/oauth2/authorize',
            'tokenUrl': 'https://ssgg-dev.auth.eu-north-1.amazoncognito.com/oauth2/token',
            'refreshUrl': 'https://ssgg-dev.auth.eu-north-1.amazoncognito.com/oauth2/token',
            'scopes':{}
        }
    }
}

# Replace default authorizer
parsed_content['components']['securitySchemes']['cognito']= cognito

# Convert swagger dict to string to replace the old authorizer name in each operation
swagger_str = json.dumps(parsed_content)

swagger_str=swagger_str.replace('SSGG-Authorizer-STG', 'cognito')

# Now you can work with parsed_content as needed
with open('API/SSGG.json', 'w', encoding='utf-8') as f:
    f.write(swagger_str)