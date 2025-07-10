#Replace with your Region
variable "region" {
    description = "AWS region needed"
    type = string
    default = "us-east-2"
}
#***START Instance time!***
variable "schedule_expression_START" {
    description = "AWS region needed"
    type = string
    default = "cron(30 8 * * ? *)"
}
#***STOP Instance time!***
variable "schedule_expression_STOP" {
    description = "AWS region needed"
    type = string
    default = "cron(30 18 * * ? *)"
}
#***Change Time Zone!***
variable "schedule_expression_timezone" {
    description = "AWS region needed"
    type = string
    default = "America/Chicago"
}