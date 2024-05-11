# creates an IAM role named "lambda-ses-role" with an assume role policy that allows the Lambda service (lambda.amazonaws.com) to assume/use this role. 

# Create IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda-ses-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AmazonSESFullAccess policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_ses_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# Attach AWSLambdaBasicExecutionRole (to have the ability to log on cloudwatch) policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// zip the lambda function files to use it 
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

# Create Lambda function to send emails
resource "aws_lambda_function" "send_email_lambda" {
  filename         = "lambda_function_payload.zip"  
  function_name    = "sendEmailFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.handler" 
  runtime          = "python3.8" 
  timeout          = 60
  memory_size      = 128
}
# create notification to send to lambda function when an create action is taken with the backend bucket 
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "tf-bucket-huda"

  lambda_function {
    lambda_function_arn = aws_lambda_function.send_email_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

# specify the required permission for the s3 bucket to can invoke the lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::tf-bucket-huda"
}


