variable iam_lambda_backup_role_name {}

resource "aws_iam_role_policy" "lambda-backup-role-policy-rds" {
  name = "${var.iam_lambda_backup_role_name}-role-policy-rds"
  role = "${aws_iam_role.lambda-backup-role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds:DeleteDBClusterSnapshot",
                "rds:ListTagsForResource",
                "rds:DescribeDBSnapshots",
                "rds:CreateDBSnapshot",
                "rds:DescribeDBClusterSnapshots",
                "rds:DescribeDBInstances",
                "rds:CreateDBClusterSnapshot",
                "rds:DeleteDBSnapshot",
                "rds:ModifyDBSnapshotAttribute",
                "rds:DescribeDBClusters",
                "rds:DescribeDBSnapshotAttributes"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "lambda-backup-role-policy-cloudwatch-logs" {
  name = "${var.iam_lambda_backup_role_name}-role-policy-cloudwatch"
  role = "${aws_iam_role.lambda-backup-role.id}"
  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:CreateLogGroup"
         ],
         "Resource":[
            "arn:aws:logs:*"
         ]
      }
   ]
}
EOF
}

resource "aws_iam_role" "lambda-backup-role" {
  name = "${var.iam_lambda_backup_role_name}-role"
  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Action": "sts:AssumeRole",
		"Principal": {
			"Service": "lambda.amazonaws.com"
		},
		"Effect": "Allow"
	}]
}
EOF
}

output "iam_lambda_backup_role_arn" {
  value = "${aws_iam_role.lambda-backup-role.arn}"
}