###
#
# CodeBuild
#
resource "aws_codebuild_project" "frontend" {
  name         = "${var.system}-${var.env}-frontend"
  service_role = aws_iam_role.codebuild_for_ecs.arn
  build_timeout = 120
 
  artifacts {
    name     = "${var.system}-${var.env}-artifacts"
    type     = "CODEPIPELINE"
    packaging = "NONE"
  }
 
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true
   }
 
  source {
    type     = "CODEPIPELINE"
    location  = aws_codecommit_repository.frontend.clone_url_http
    buildspec = data.template_file.buildspec_template_file.rendered
  }
}

data "aws_caller_identity" "current" {}

data "template_file" "buildspec_template_file" {
  template = <<EOF
version: 0.2
phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - $(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com)
      - REPOSITORY_URI_APP=${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.repository_frontend}
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
  build:
    commands:
      - docker build -t $REPOSITORY_URI_APP:latest -f Dockerfile .
      - docker tag $REPOSITORY_URI_APP:latest $REPOSITORY_URI_APP:$IMAGE_TAG
  post_build:
    commands:
      - docker push $REPOSITORY_URI_APP:latest
      - docker push $REPOSITORY_URI_APP:$IMAGE_TAG
      - cat taskdef-template.json | sed -e s@\<IMAGE1_NAME\>@$REPOSITORY_URI_APP:$IMAGE_TAG@ > taskdef.json
artifacts:
    files:
      - appspec.yml
      - taskdef.json
EOF
}