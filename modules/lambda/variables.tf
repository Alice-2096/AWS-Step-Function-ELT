variable "region" {
  description = "The AWS region to deploy lambda function."
}
variable "stream_name" {
  description = "The name of the Kinesis data stream to push events to."
}
variable "stream_arn" {
  description = "The ARN of the Kinesis data stream to push events to."
}
variable "state_machine_arn" {
  description = "The ARN of the Step Function to trigger from Kinesis."
}
variable "s3_source_bucket_arn" {
  description = "The ARN of the S3 bucket to trigger lambda function."
}
variable "s3_source_bucket_id" {
  description = "id of the S3 bucket to trigger lambda function."
}

#################### IAM ####################
variable "kinesis_producer_policy_arn" {
  description = "The ARN of the IAM policy that allows Lambda to put records to Kinesis."
}
variable "invoke_step_function_policy_arn" {
  description = "The ARN of the IAM policy that allows Lambda to invoke Step Function."
}
variable "pull_from_kinesis_policy_arn" {
  description = "The ARN of the IAM policy that allows Lambda to access Kinesis data stream."
}
variable "s3_access_policy_arn" {
  description = "The ARN of the IAM policy that allows Lambda to access S3 bucket."
}


