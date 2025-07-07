
#Create an IAM policy and role for your Lambda function
resource "aws_iam_role_policy" "lambda_ec2startstop_policy" {
  name = "lambda_ec2startstop_policy"
  role = aws_iam_role.lambda_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:Start*",
          "ec2:Stop*",
          "kms:CreateGrant"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

#Create Lambda functions that stop and start your instances

# Package the START Lambda function code
data "archive_file" "start_ec2" {
  type        = "zip"
  source_file = "${path.module}/start_lambda_code/index.py"
  output_path = "${path.module}/start_lambda_code/function.zip"
}

# Lambda START function
resource "aws_lambda_function" "start_ec2_function" {
  filename         = data.archive_file.start_ec2.output_path
  function_name    = "start_ec2_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.lambda_handler"
  region           = "us-east-2"
  source_code_hash = data.archive_file.start_ec2.output_base64sha256

  runtime = "python3.13"
  tags = {
    Environment = "production"
  }
}


# Package the STOP Lambda function code
data "archive_file" "stop_ec2" {
  type        = "zip"
  source_file = "${path.module}/stop_lambda_code/index.py"
  output_path = "${path.module}/stop_lambda_code/function.zip"
}

# Lambda stop function
resource "aws_lambda_function" "stop_ec2_function" {
  filename         = data.archive_file.stop_ec2.output_path
  function_name    = "stop_ec2_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.lambda_handler"
  region           = "us-east-2"
  source_code_hash = data.archive_file.stop_ec2.output_base64sha256

  runtime = "python3.13"
  tags = {
    Environment = "production"
  }
}

resource "aws_iam_role" "eventbridge_scheduler_execution" {
  name = "eventbridge-scheduler-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "scheduler.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eventbridge_sch_policy" {
  name = "eventbridge_sch_policy"
  role = aws_iam_role.eventbridge_scheduler_execution.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = "*"
      }
    ]
  })
}

#EventBridge Scheduler START Instance
resource "aws_scheduler_schedule" "ec2_start_sch" {
  name       = "ec2_start_sch"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = "cron(45 18 * * ? *)"
  schedule_expression_timezone = "America/Chicago"

  target {
    arn      = aws_lambda_function.start_ec2_function.arn
    role_arn = aws_iam_role.eventbridge_scheduler_execution.arn
  }
}

#EventBridge Scheduler STOP Instance
resource "aws_scheduler_schedule" "ec2_stop_sch" {
  name       = "ec2_stop_sch"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = "cron(50 18 * * ? *)"
  schedule_expression_timezone = "America/Chicago"

  target {
    arn      = aws_lambda_function.start_ec2_function.arn
    role_arn = aws_iam_role.eventbridge_scheduler_execution.arn
  }
}