locals {
  definition_template = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Parallel",
  "States": {
    "Parallel": {
      "Type": "Parallel",
      "Next": "Choice",
      "Branches": [
        {
          "StartAt": "processor-1",
          "States": {
            "processor-1": {
              "Type": "Task",
              "Resource": "arn:aws:states:::lambda:invoke",
              "Parameters": {
                "Payload.$": "$",
                "FunctionName": "${var.lambda_step_function_1_arn}"
              },
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 1,
                  "MaxAttempts": 3,
                  "BackoffRate": 2
                }
              ],
              "End": true,
              "OutputPath": "$.Payload"
            }
          }
        },
        {
          "StartAt": "processor-2",
          "States": {
            "processor-2": {
              "Type": "Task",
              "Resource": "arn:aws:states:::lambda:invoke",
              "Parameters": {
                "Payload.$": "$",
                "FunctionName": "${var.lambda_step_function_2_arn}"
              },
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 1,
                  "MaxAttempts": 3,
                  "BackoffRate": 2
                }
              ],
              "End": true,
              "OutputPath": "$.Payload"
            }
          }
        }
      ]
    },
    "Choice": {
      "Type": "Choice",
      "Choices": [
        {
          "Or": [
            {
              "Variable": "$[0].Payload.status",
              "StringEquals": "FAILED"
            },
            {
              "Variable": "$[1].Payload.status",
              "StringEquals": "FAILED"
            }
          ],
          "Next": "handleFailure"
        }
      ],
      "Default": "PutObject"
    },
    "handleFailure": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "${var.lambda_step_function_handle_failure_arn}"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 1,
          "MaxAttempts": 3,
          "BackoffRate": 2
        }
      ],
      "End": true
    },
    "PutObject": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "Body": {
          "status.$": "$[0].Payload.status",
          "message": "Processing complete!"
        },
        "Bucket": "lab-bucket-1234",
        "Key": "MyData"
      },
      "Resource": "arn:aws:states:::aws-sdk:s3:putObject"
    }
  }
}
EOF
}

module "step-functions" {
  source      = "terraform-aws-modules/step-functions/aws"
  version     = "4.2.0"
  name        = var.state_machine_name
  definition  = local.definition_template
  create_role = true
  publish     = true
  logging_configuration = {
    include_execution_data = true
    level                  = "ALL"
  }

  service_integrations = { # will automatically create policies to attach to the role 
    lambda = {
      lambda = [
        var.lambda_step_function_1_arn,
        var.lambda_step_function_2_arn,
      var.lambda_step_function_handle_failure_arn]
    }
  }

  attach_policy_statements = true
  policy_statements = {
    s3_read = {
      effect    = "Allow",
      actions   = ["s3:PutObject"],
      resources = [data.aws_s3_bucket.bucket.arn]
    }
  }

  type = "STANDARD"
}

# fetch s3 bucket arn
data "aws_s3_bucket" "bucket" {
  bucket = "lab-bucket-1234"
}
