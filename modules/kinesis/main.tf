resource "aws_kinesis_stream" "stream" {
  name             = var.stream_name
  shard_count      = var.shard_count
  retention_period = var.retention_period

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  encryption_type = "KMS"
  kms_key_id      = var.kinesis_kms_key_arn

  tags = {
    Environment = "dev"
  }
}

