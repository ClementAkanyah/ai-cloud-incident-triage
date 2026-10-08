
resource "aws_s3_bucket" "runbooks" {
  bucket_prefix = "ai-incident-triage-runbooks-"

  tags = {
    Project = "AI Cloud Incident Triage"
    Purpose = "Approved incident response runbooks"
  }
}

resource "aws_s3_bucket_public_access_block" "runbooks" {
  bucket = aws_s3_bucket.runbooks.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "runbooks" {
  bucket = aws_s3_bucket.runbooks.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "runbooks" {
  bucket = aws_s3_bucket.runbooks.id

  versioning_configuration {
    status = "Enabled"
  }
}
