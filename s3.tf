#------------------------------
# S3
#------------------------------
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project}-${var.env}-nemunemu-bucket"
  force_destroy = true
  versioning {
    enabled = false
  }
  tags = {
    Name    = "${var.project}-${var.env}-nemunemu-bucket"
    Project = var.project
    Env     = var.env
  }
}
resource "aws_s3_bucket_public_access_block" "bucket-access-block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = false
  depends_on = [
    aws_s3_bucket_policy.bucket-policy
  ]
}
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3-bucket-policy-document.json
}

data "aws_iam_policy_document" "s3-bucket-policy-document" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    principals {
      type = "*"
      identifiers = ["*"]
    }
  }
}