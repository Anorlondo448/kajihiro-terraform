###
#
# IAM for CodeBuild
#
resource "aws_iam_role" "codebuild_for_ecs" {
  name  = "${var.system}-${var.env}-codebuild-for-ecs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_for_ecs" {
  role   = aws_iam_role.codebuild_for_ecs.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "${var.system}-${var.env}-codebuild-policy"
  description = "${var.system}-${var.env}-codebuild-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:*",
        "codecommit:*",
        "s3:*",
        "ecr:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
