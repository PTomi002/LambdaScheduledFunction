variable "lambda_backup_role_arn" {}
variable "lambda_backup_function_name" {}
variable "lambda_handler_name" {}
variable "lambda_application_jar_name" {}
variable "cloudwatch_trigger_source_arn" {}
variable "cluster" {}

resource "aws_lambda_function" "lambda-backup" {
  filename = "${var.lambda_application_jar_name}"
  function_name = "${var.lambda_backup_function_name}-function"
  role = "${var.lambda_backup_role_arn}"
  handler = "${var.lambda_handler_name}"
  runtime = "python3.6"
  timeout = 300
  environment {
    variables {
      CLUSTER = "${var.cluster}"
    }
  }
  source_code_hash = "${base64sha256(file("${var.lambda_application_jar_name}"))}"
}

resource "aws_lambda_permission" "lambda-backup-trigger-permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda-backup.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${var.cloudwatch_trigger_source_arn}"
}

output "lambda_backup_function_arn" {
  value = "${aws_lambda_function.lambda-backup.arn}"
}