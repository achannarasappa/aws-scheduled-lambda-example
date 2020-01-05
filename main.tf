provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

######
# Role & Policies
######

resource "aws_iam_role" "scheduled_lambda" {
  name = "scheduled_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Allow the Lambda to write to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda-basic-execution-policy-attach" {
  role       = "${aws_iam_role.scheduled_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

######
# Compute
######

# Define a Lambda function to be on the interval
resource "aws_lambda_function" "scheduled_lambda" {
  function_name    = "scheduled_lambda"
  filename         = var.package
  source_code_hash = filebase64sha256(var.package)

  handler = "src/handler.start"
  runtime = "nodejs10.x"

  role = aws_iam_role.scheduled_lambda.arn

}

# Allow CloudWatch to invoke the Lambda
resource "aws_lambda_permission" "scheduled_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.scheduled_lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_lambda.arn
}

######
# Scheduler
######

# Set the function to run once a minute
resource "aws_cloudwatch_event_rule" "scheduled_lambda" {
  name        = "scheduled_lambda"
  description = "Runs a Lambda function on a schedule"

  schedule_expression = "rate(1 minute)"
}

# Associate the event rule with the lambda
resource "aws_cloudwatch_event_target" "scheduled_lambda" {
  rule      = "${aws_cloudwatch_event_rule.scheduled_lambda.name}"
  arn       = "${aws_lambda_function.scheduled_lambda.arn}"
}