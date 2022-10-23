###
#
# CodeBuild
#
# S3 for Artifact
resource "aws_s3_bucket" "artifact" {
  bucket = "${var.system}-${var.env}-codepipeline-artifact"
  tags = {
    Name = "${var.system}-${var.env}"
  }
}

resource "aws_s3_bucket_public_access_block" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.system}-${var.env}-codepipeline"
  role_arn = aws_iam_role.codepipeline_for_ecs.arn

  artifact_store {
    location = aws_s3_bucket.artifact.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        RepositoryName = aws_codecommit_repository.frontend.repository_name
        BranchName     = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.frontend.id
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["build"]
      version         = "1"

      configuration = {
        ApplicationName                = aws_codedeploy_app.frontend.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.frontend.id
        TaskDefinitionTemplateArtifact = "build"
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "build"
        AppSpecTemplatePath            = "appspec.yml"
      }
    }
  }
}