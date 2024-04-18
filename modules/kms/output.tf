output "kinesis_kms_key_arn" {
  value = aws_kms_key.encryption_key.arn
}
output "s3_source_kms_key_arn" {
  value = aws_kms_key.encryption_key_s3_source_bucket.arn
}
