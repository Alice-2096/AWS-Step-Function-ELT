variable "stream_name" {
  description = "The name of the Kinesis stream"
}
variable "shard_count" {
  description = "The number of shards for the Kinesis stream"
}
variable "retention_period" {
  description = "The number of hours to retain data in the stream"
  default     = 24
}
variable "kinesis_kms_key_arn" {
  description = "The ARN of the KMS key to use for encryption"
}
