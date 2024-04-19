output "lambda_step_function_1_arn" {
  description = "The ARN of the first lambda function"
  value       = module.lambda_function_step_function[0].lambda_function_arn
}
output "lambda_step_function_2_arn" {
  description = "The ARN of the second lambda function"
  value       = module.lambda_function_step_function[1].lambda_function_arn
}
output "lambda_step_function_handle_failure_arn" {
  description = "The ARN of the lambda function to handle failures"
  value       = module.lambda_function_step_function[2].lambda_function_arn
}
