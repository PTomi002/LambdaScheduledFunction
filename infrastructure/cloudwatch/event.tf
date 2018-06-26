variable "cloudwatch_event_cron_expression" {}
variable "cloudwatch_event_rule_name" {}
variable "lambda_backup_function_arn" {}

resource "aws_cloudwatch_event_rule" "cloudwatch-scheduled-event" {
  name = "${var.cloudwatch_event_rule_name}-event-rule"
  schedule_expression = "${var.cloudwatch_event_cron_expression}"
}

resource "aws_cloudwatch_event_target" "cloudwatch-scheduled-event-target" {
  rule = "${aws_cloudwatch_event_rule.cloudwatch-scheduled-event.name}"
  arn = "${var.lambda_backup_function_arn}"
}

output "cloudwatch_scheduled_event_arn" {
  value = "${aws_cloudwatch_event_rule.cloudwatch-scheduled-event.arn}"
}