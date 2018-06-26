variable "lambda_handler_name" {}
variable "application_jar_name" {}
variable "cron_expression" {}
variable "cluster" {}
variable "environment" {}

resource "random_string" "random-suffix" {
  length = 8
  special = false
}

module "lambda-backup-role" {
  source = "iam"
  iam_lambda_backup_role_name = "${var.environment}-lambda-backup-${random_string.random-suffix.result}"
}

module "lambda-backup-function" {
  source = "lambda"
  lambda_backup_role_arn = "${module.lambda-backup-role.iam_lambda_backup_role_arn}"
  lambda_handler_name = "${var.lambda_handler_name}"
  cloudwatch_trigger_source_arn = "${module.cloudwatch-trigger.cloudwatch_scheduled_event_arn}"
  lambda_application_jar_name = "${var.application_jar_name}"
  cluster = "${var.cluster}"
  lambda_backup_function_name = "${var.environment}-lambda-backup-${random_string.random-suffix.result}"
}

module "cloudwatch-trigger" {
  source = "cloudwatch"
  cloudwatch_event_cron_expression = "${var.cron_expression}"
  cloudwatch_event_rule_name = "${var.environment}-lambda-backup-${random_string.random-suffix.result}"
  lambda_backup_function_arn = "${module.lambda-backup-function.lambda_backup_function_arn}"
}