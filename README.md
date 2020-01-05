## Scheduled AWS Lambda function with Terraform

Minimal example of a Lambda function triggered on an interval.

### Setup

1. Install [terraform](https://www.terraform.io/downloads.html)
1. [Configure aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
1. Initialize terraform `terraform init`

### Usage

1. Build `rm -rf src.zip && zip -r ./src.zip ./src`
1. Push to AWS `terraform apply`
1. Invoke function `aws lambda invoke --invocation-type RequestResponse --function-name scheduled_lambda --region us-east-1  --profile default out.txt`
1. View log output on [CloudWatch](https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logStream:group=/aws/lambda/scheduled_lambda;streamFilter=typeLogStreamPrefix)