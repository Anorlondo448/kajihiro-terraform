###
#
# IAM for CodeDeploy
#
resource "aws_iam_role" "codedeploy_for_ecs" {
  name  = "${var.system}-${var.env}-codedeploy-for-ecs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy_for_ecs" {
  role       = aws_iam_role.codedeploy_for_ecs.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}