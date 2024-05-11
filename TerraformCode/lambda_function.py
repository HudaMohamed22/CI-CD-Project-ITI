import boto3
import json
from botocore.exceptions import ClientError
from datetime import datetime

def send_email(event, context):

    SENDER_EMAIL = 'marlymohamed30@gmail.com'
    RECIPIENT_EMAIL = 'marlymohamed30@gmail.com'
    
    # Email subject and body
    SUBJECT = 'Terraform State File Change Detected'
    BODY_TEXT = f'The Terraform state file was modified at {datetime.now()}.\n\nObject URL: {event["Records"][0]["s3"]["object"]["key"]}'
    
    ses_client = boto3.client('ses')
    
    # Try to send the email
    try:
        response = ses_client.send_email(
            Source=SENDER_EMAIL,
            Destination={
                'ToAddresses': [
                    RECIPIENT_EMAIL,
                ]
            },
            Message={
                'Subject': {
                    'Data': SUBJECT
                },
                'Body': {
                    'Text': {
                        'Data': BODY_TEXT
                    }
                }
            }
        )
        print("Email sent! Message ID:", response['MessageId'])
        return {
            'statusCode': 200,
            'body': 'Email sent successfully!'
        }
    except ClientError as e:
        print("Error sending email:", e.response['Error']['Message'])
        return {
            'statusCode': 500,
            'body': 'Error sending email'
        }

# This is the entry point for Lambda execution
def handler(event, context):
    return send_email(event, context)
