###
#
# S3
#
resource "aws_s3_bucket" "vpc_flow_logs" {
  bucket = "${var.system}-${var.env}-vpc-flow-logs"

  tags = {
    Name = "${var.system}-${var.env}-vpc-flow-logs"
  }
}

resource "aws_s3_bucket_public_access_block" "vpc_flow_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}