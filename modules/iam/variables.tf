variable "state_machine_arn" {
  description = "The ARN of the Step Function to trigger from lambda consumer."
}
variable "stream_arn" {
  description = "The ARN of the Kinesis data stream to push events to."
}
variable "s3_source_bucket_arn" {
  description = "The ARN of the S3 bucket to trigger lambda function."

}
