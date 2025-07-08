Terraform code to implement ec2 stop/start with Lambda / Eventbridge. 
Code deploys resources used in AWS doc "How do I use Lambda to stop and start Amazon EC2 instances at regular intervals?" (https://repost.aws/knowledge-center/start-stop-lambda-eventbridge)

Before $ terraform apply, please:
1. Update to your needed aws region
    provider.tf > region = "us-east-2"
3. Update the cron / timezone schedule for the (2) aws_scheduler_schedule blocks.
    main.tf > schedule_expression          = "cron(15 19 * * ? *)"
    main.tf > schedule_expression_timezone = "America/Chicago"
   *helpful site to determine cron code: https://www.awscronjobs.com/aws
