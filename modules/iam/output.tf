output "s3_access_policy_arn" {
  value = aws_iam_policy.s3_access.arn
}
output "kinesis_producer_access_policy_arn" {
  value = aws_iam_policy.kinesis_producer_access.arn
}
output "invoke_step_function_policy_arn" {
  value = aws_iam_policy.invoke_step_function.arn
}

output "kinesis_consumer_access_policy_arn" {
  value = aws_iam_policy.pull_from_kinesis.arn
}
output "kms_decrypt_kinesis_policy_arn" {
  value = aws_iam_policy.kms_decrypt_kinesis_policy.arn

}
