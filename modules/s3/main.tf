# bucket basic config 
resource "aws_s3_bucket" "source_bucket" {
  bucket        = "${var.project_name}-bucket"
  force_destroy = true
  tags = {
    Name = "${var.project_name}-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.source_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "acl" {
  bucket = aws_s3_bucket.source_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# enable versioning and encryption 
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.source_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# allow public read and write 
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.acl,
  ]

  bucket = aws_s3_bucket.source_bucket.id
  acl    = "public-read-write"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_encryption" {
  bucket = aws_s3_bucket.source_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}



