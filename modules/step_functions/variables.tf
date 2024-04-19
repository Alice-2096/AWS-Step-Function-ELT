variable "state_machine_name" {
  description = "The name of the state machine"
  type        = string
}
variable "state_machine_definition" {
  description = "The definition of the state machine"
  type        = string
  default     = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Pass",
  "States": {
    "Pass": {
      "Type": "Pass",
      "End": true
    }
  }
}
EOF 
}

#################### lambdas ####################
variable "lambda_step_function_1_arn" {
  description = "The ARN of the first lambda function"
  type        = string
}
variable "lambda_step_function_2_arn" {
  description = "The ARN of the second lambda function"
  type        = string
}
variable "lambda_step_function_handle_failure_arn" {
  description = "The ARN of the lambda function to handle failures"
  type        = string
}

