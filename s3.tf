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